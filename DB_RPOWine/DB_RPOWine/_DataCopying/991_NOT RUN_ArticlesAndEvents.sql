print '----- Load from Articles ----'
GO
--SELECT TOP 1000 * FROM [RPOWineData].[dbo].[ArticlesBody]
--select top 20 * from [RPOWineData].[dbo].Articles  
--select * from Users order by FullName
--exec srv.ChangeUserID @OldUserId =-5, @NewUserId=777638
--delete Users where UserId = -5
--select * from #t where ArticleIdN = 2
--select * from Article a join #t on a.AuthorId = #t.AuthorUserId and a.Title = #t.Title and a.Date = #t.StartDate where #t.ArticleIdN = 2
-------------- processing : creating TastingEvents --------------------
; with a as (
	select 
		Country = isnull(Country, ''), Region = isnull(Region, ''), Location = isnull(Location, ''),
		Publication, Issue, 
		Author = Source, sourceDate,
		a.Title, a.Topic,
		ArticleId, idN,
		a.Pages, a.dateUpdated
	from RPOWineData..Articles a
		--join RPOWineData..tocMap m on a.idN = m.idN
		--fixedId = m.fixedId,
)
select 
	[Key] = Publication + '. ' + Issue + ':' + ltrim(rtrim(a.Country + ' ' + a.Region + ' ' + a.Location)),
	PublicationID = isnull(p.ID, 0), Publication = a.Publication,
	IssueID = i.ID, Issue = a.Issue,  
	ArticleId = a.ArticleId, ArticleIdN = a.idN,
	Title = a.Title, Topic = a.Topic,
	Location = ltrim(rtrim(a.Country + ' ' + a.Region + ' ' + a.Location)),
	CountryID = isnull(lc.ID, 0), 
	RegionID = isnull(lr.ID, 0), 
	LocationID = isnull(ll.ID, 0), 
	StartDate = a.sourceDate, 
	Author = a.Author, AuthorUserId = isnull(u.UserId, 0),
	Pages = a.Pages,
	dateUpdated = a.dateUpdated
into #t
from a
	join Publication p (nolock) on a.Publication = p.Name
	join Issue i (nolock) on i.PublicationID = p.ID and a.Issue = i.Title
	left join LocationCountry lc (nolock) on a.Country = lc.Name
	left join LocationRegion lr (nolock) on a.Region = lr.Name
	left join LocationLocation ll (nolock) on a.Location = ll.Name
	left join Users u (nolock) on isnull(a.Author, '') != '' and a.Author = u.FullName
order by [Key], IssueID, Topic desc, ArticleId

alter table #t add ID int not null identity(1,1);

declare @id int = 0, 
	@prevKey varchar(50) = '', @Key varchar(50) = '', @issueID int, @artID int,
	@teID int = 0,
	@tempID int

set xact_abort on
set nocount on
BEGIN TRAN
	select @id = 1
	while exists(select * from #t where ID = @id) begin		-- and isnull(@id, 0) < 10
		select @Key = [Key], @issueID = IssueID, @artID = ArticleId from #t where ID = @id
		--select @id, @prevKey, @Key, @issueID

		if (@prevKey != @Key) begin
			-- Add TestingEvent "header"
			insert into TastingEvent (ParentID, UserId, Title, StartDate, EndDate,
				Location, locCountryID, locRegionID, locLocationID, locLocaleID, locSiteID,
				Notes, SortOrder, created, updated, WF_StatusID)
			select ParentID=0, UserId=isnull(AuthorUserId,0), 
				Title = case 
					when len(isnull(Location, '')) > 0 and len(isnull(Topic, '')) > 0 then Location + ' - ' + Topic 
					when len(isnull(Location, '')) > 0 and len(isnull(Topic, '')) = 0 then Location
					else isnull(Topic, Title)
				end, 
				StartDate=StartDate, EndDate=NULL,
				Location = Location, locCountryID=CountryID, locRegionID=RegionID, locLocationID=LocationID, locLocaleID=0, locSiteID=0,
				Notes=NULL, SortOrder=0, created=isnull(isnull(dateUpdated, StartDate),getdate()), updated=dateUpdated, WF_StatusID=100
			from #t where ID = @id
			select @teID = scope_identity()
			
			if @teID > 0 and not exists(select * from Issue_TastingEvent where IssueID = @issueID and TastingEventID = @teID) begin
				insert into Issue_TastingEvent (IssueID, TastingEventID)
				values (@issueID, @teID)
				
				if @artID is NOT NULL begin
					insert into TastingEvent_TasteNote (TastingEventID, TasteNoteID)
					select @teID, tn.ID
					from #t
						join RPOWineData..tocMap m on #t.ArticleId = m.idN
						join TasteNote tn on tn.oldFixedId = m.fixedId
					where #t.ArticleId is NOT NULL
						and #t.ID = @ID
				end
			end
			set @prevKey = @Key
		end

		-- Add Article
		if not exists(select * from Article a join #t on a.AuthorId = #t.AuthorUserId and a.Title = #t.Title and a.Date = #t.StartDate where #t.ID = @id) begin
			insert into Article (AuthorId, Title, Date, Notes, MetaTags, WF_StatusID, 
				oldArticleIdN, oldArticleId)
			select top 1 --distinct
				#t.AuthorUserId, #t.Title, #t.StartDate, '', '', 100,
				#t.ArticleIdN, #t.ArticleId
			from #t 
				--join [RPOWineData].[dbo].[Articles] a on #t.ArticleId = a.ArticleId and #t.ArticleIdNKey = a.ArticleIdNKey
				--join [RPOWineData].[dbo].[ArticlesBody] ab on a.ArticleId = ab.id
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

		-- Adding Issue_Article linkage
	insert into Issue_Article(IssueID, ArticleID)
	select ite.IssueID, tea.ArticleID
	from Issue_TastingEvent ite
		join TastingEvent_Article tea on ite.TastingEventID = tea.TastingEventID

COMMIT TRAN
--ROLLBACK TRAN

drop table #t
print 'Done.'