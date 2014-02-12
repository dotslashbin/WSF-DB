print '----- Load from Articles ----'
GO
--SELECT TOP 1000 * FROM [RPOWineData2].[dbo].[ArticlesBody]
--select top 20 * from [RPOWineData2].[dbo].Articles  
-------------- processing : creating TastingEvents --------------------
select 
	[Key] = Issue + ':' + ltrim(rtrim(isnull(a.Country, '') + ' ' + isnull(a.Region, ''))),
	itn.IssueID, Issue,  
	ArticleId = itn.oldArticleId, 
	ArticleIdNKey = itn.oldArticleIdNKey, 
	Title = a.Title, a.Topic,
	Location = ltrim(rtrim(isnull(a.Country, '') + ' ' + isnull(a.Region, ''))),
	CountryID = isnull(lc.ID, 0), 
	RegionID = isnull(lr.ID, 0), 
	StartDate = sourceDate, 
	Publication, PublicationID = isnull(p.ID, 0),
	Source, UserId = isnull(u.UserId, 0),
	Pages = max(Pages),
	dateUpdated = max(dateUpdated)
into #t
from RPOWineData2..Articles a (nolock)
	join Issue_TasteNote itn (nolock) on a.ArticleId = itn.oldArticleId and a.ArticleIdNKey = itn.oldArticleIdNKey
	join Publication p (nolock) on a.Publication = p.Name
	join Issue i (nolock) on itn.IssueID = i.ID and i.PublicationID = p.ID and a.Issue = i.Title
	left join LocationCountry lc (nolock) on a.Country = lc.Name
	left join LocationRegion lr (nolock) on a.Region = lr.Name
	left join Users u (nolock) on a.Source = u.FullName
group by itn.IssueID, Issue, itn.oldArticleId, itn.oldArticleIdNKey, 
	a.Title, a.Topic, 
	ltrim(rtrim(isnull(a.Country, '') + ' ' + isnull(a.Region, ''))), isnull(lc.ID, 0), isnull(lr.ID, 0), 
	a.sourceDate,
	Publication, isnull(p.ID, 0), Source, isnull(u.UserId, 0)
order by [Key], IssueID, Topic desc, ArticleId

alter table #t add ID int not null identity(1,1);

declare @id int = 0, 
	@prevKey varchar(50) = '', @Key varchar(50) = '', @issueID int,
	@teID int = 0,
	@tempID int

set xact_abort on
set nocount on
BEGIN TRAN
	select @id = 1
	while exists(select * from #t where ID = @id) begin		-- and isnull(@id, 0) < 10
		select @Key = [Key], @issueID = IssueID from #t where ID = @id
		--select @id, @prevKey, @Key, @issueID

		if (@prevKey != @Key) begin
			-- Add TestingEvent "header"
			insert into TastingEvent (ParentID, UserId, Title, StartDate, EndDate,
				Location, locCountryID, locRegionID, locLocationID, locLocaleID, locSiteID,
				Notes, SortOrder, created, updated, WF_StatusID)
			select ParentID=0, UserId=isnull(UserId,0), 
				Title = case 
					when len(isnull(Location, '')) > 0 and len(isnull(Topic, '')) > 0 then Location + ' - ' + Topic 
					when len(isnull(Location, '')) > 0 and len(isnull(Topic, '')) = 0 then Location
					else isnull(Topic, Title)
				end, 
				StartDate=StartDate, EndDate=NULL,
				Location = Location, locCountryID=CountryID, locRegionID=RegionID, locLocationID=0, locLocaleID=0, locSiteID=0,
				Notes=NULL, SortOrder=0, created=isnull(isnull(dateUpdated, StartDate),getdate()), updated=dateUpdated, WF_StatusID=100
			from #t where ID = @id
			select @teID = scope_identity()
			
			if @teID > 0 and not exists(select * from Issue_TastingEvent where IssueID = @issueID and TastingEventID = @teID) begin
				insert into Issue_TastingEvent (IssueID, TastingEventID)
				values (@issueID, @teID)
				
				insert into TastingEvent_TasteNote (TastingEventID, TasteNoteID)
				select @teID, itn.TasteNoteID
				from #t
					join Issue_TasteNote itn (nolock) on #t.IssueID = itn.IssueID
						and #t.ArticleId = itn.oldArticleId and #t.ArticleIdNKey = itn.oldArticleIdNKey
				where #t.ID = @ID and isnull(#t.ArticleId, 0) > 0 and isnull(#t.ArticleIdNKey, 0) > 0

			end
			set @prevKey = @Key
		end

		-- Add Article
		if not exists(select * from Article a join #t on a.UserId = #t.UserId and a.Title = #t.Title and a.Date = #t.StartDate where #t.ID = @id) begin
			insert into Article (UserId, Title, Date, Notes, MetaTags, WF_StatusID, 
				oldArticleIdNKey, oldArticleId)
			select top 1 --distinct
				#t.UserId, #t.Title, #t.StartDate, ab.body, ab.meta, 100,
				#t.ArticleIdNKey, #t.ArticleId
			from #t 
				join [RPOWineData2].[dbo].[Articles] a on #t.ArticleId = a.ArticleId and #t.ArticleIdNKey = a.ArticleIdNKey
				join [RPOWineData2].[dbo].[ArticlesBody] ab on a.ArticleId = ab.id
			where #t.ID = @id
			select @tempID = scope_identity()
			
			if isnull(@tempID, 0) > 0 begin
				-- add linkage to testing notes
				insert into TastingEvent_Article (TastingEventID, ArticleID)
				select @teID, @tempID
			end
		end
		
		select @id = @id + 1	--min(ID) from #t where ID > @id
		if @id % 100 = 0
			print @id
	end
COMMIT TRAN
--ROLLBACK TRAN

drop table #t
print 'Done.'