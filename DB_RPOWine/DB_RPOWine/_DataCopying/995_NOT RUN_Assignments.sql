-- ======= Wine ========
--
-- Data Source: RPOWineData.dbo
--
--
USE [RPOWine]
GO
print '---------- Deleting Data... ------------'
GO
--rollback tran
--truncate table Issue_Article
--truncate table Assignment_TastingEvent
--truncate table TastingEvent_TasteNote
--truncate table Assignment_Article
--truncate table Assignment_Resource
--truncate table Assignment_ResourceD
--delete Article
--delete Assignment
--delete TastingEvent
--DBCC CHECKIDENT (Article, RESEED, 1)
--DBCC CHECKIDENT (Assignment, RESEED, 1)
--DBCC CHECKIDENT (TastingEvent, RESEED, 1)
--GO
--select count(*) from Article
--select count(*) from Issue_Article
--select count(*) from Assignment
--select count(*) from TastingEvent
--select count(*) from Assignment_Article
--select count(*) from TastingEvent_TasteNote
--GO
print '---------- Loading Data... ------------'
GO
; with a as (
	select 
		ArticleId, idN, ArticleIdNKey,
		Country = isnull(Country, ''), Region = isnull(Region, ''), Location = isnull(Location, ''),
		Publication, Issue, 
		Author = Source, 
		StartDate = isnull(a.sourceDate, a.dateUpdated),
		a.Title, a.Topic,
		a.Pages, a.dateUpdated
	from RPOWineData.dbo.Articles a
		--join RPOWineData..tocMap m on a.idN = m.idN
		--fixedId = m.fixedId,
)
select 
	[Key] = Publication + '. ' + Issue + ': ' + ltrim(rtrim(a.Country + ' ' + a.Region + ' ' + a.Location)),
	PublicationID = isnull(p.ID, 0), Publication = a.Publication,
	IssueID = i.ID, Issue = a.Issue,  
	ArticleId = a.ArticleId, ArticleIdN = a.idN, ArticleIdNKey = a.ArticleIdNKey,
	Title = a.Title, Topic = a.Topic,
	Location = ltrim(rtrim(a.Country + ' ' + a.Region + ' ' + a.Location)),
	CountryID = isnull(lc.ID, 0), 
	RegionID = isnull(lr.ID, 0), 
	LocationID = isnull(ll.ID, 0), 
	StartDate = a.StartDate,
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

------ missing issue and publication
--select a.idN, 
--	Publication = max(isnull(a.Publication, w.Publication)),
--	Issue = max(isnull(a.Issue, w.Issue))
--from RPOWineData.dbo.Articles a 
--	join RPOWineData..tocMap m on a.idN = m.idN
--	join (select FixedId, Publication, Issue from RPOWineData.dbo.Wine) w on m.fixedId = w.FixedId
--where a.Issue is NULL
--group by a.idN

-------------------------------------------

declare @id int = 0, 
	@prevKey varchar(50) = '', @Key varchar(50) = '', @issueID int, @artID int, @assID int,	@teID int, 
	@tempID int

set xact_abort on
set nocount on
BEGIN TRAN
	select @id = 1
	while exists(select * from #t where ID = @id) begin		-- and isnull(@id, 0) < 10
		select @Key = [Key], @issueID = IssueID from #t where ID = @id
		--select @id, @prevKey, @Key, @issueID
	
		-- Article
		insert into Article (AuthorId, Title, Date, Notes, MetaTags, WF_StatusID, 
			oldArticleIdN, oldArticleId, oldArticleIdNKey)
		select #t.AuthorUserId, #t.Title, #t.StartDate, '', '', 100,
			#t.ArticleIdN, #t.ArticleId, #t.ArticleIdNKey
		from #t
		where ID = @id
		select @artID = scope_identity()
		
		insert into Issue_Article(IssueID, ArticleID)
		values (@issueID, @artID)
	
		if (@prevKey != @Key) begin
			select @prevKey = @Key
			-- Assignment
			insert into Assignment (IssueID, AuthorId, Title, Deadline, Notes, WF_StatusID)
			select #t.IssueID, 0, #t.[Key], i.PublicationDate, '', 100 
			from #t 
				join Issue i on #t.IssueID = i.ID
			where #t.ID = @id
			select @assID = scope_identity()
			
			-- Flights == TastingEvents
			insert into TastingEvent (UserId, Title, StartDate, EndDate,
				Location, locCountryID, locRegionID, locLocationID, locLocaleID, locSiteID,
				Notes, SortOrder, created, updated, WF_StatusID)
			select 
				UserId=isnull(AuthorUserId,0), 
				Title = case 
					when len(isnull(Location, '')) > 0 and len(isnull(Topic, '')) > 0 then Location + ' - ' + Topic 
					when len(isnull(Location, '')) > 0 and len(isnull(Topic, '')) = 0 then Location
					else isnull(Topic, Title)
				end, 
				StartDate=StartDate, EndDate=NULL,
				Location = Location, locCountryID=CountryID, locRegionID=RegionID, locLocationID=LocationID, locLocaleID=0, locSiteID=0,
				Notes=NULL, SortOrder=0, created=isnull(isnull(dateUpdated, StartDate),getdate()), updated=dateUpdated, WF_StatusID=100
			from #t 
			where ID = @id
			select @teID = scope_identity()
			
			insert into Assignment_TastingEvent(AssignmentID, TastingEventID)
			values (@assID, @teID)

			insert into TastingEvent_TasteNote (TastingEventID, TasteNoteID)
			select @teID, tn.ID
			from #t
				join RPOWineData.dbo.tocMap m on #t.ArticleIdN = m.idN
				join TasteNote tn on tn.oldFixedId = m.fixedId
			where #t.ArticleIdN is NOT NULL
				and #t.ID = @ID
				
		end

		if (@assID is NOT NULL and @artID is NOT NULL) begin		
			insert into Assignment_Article(AssignmentID, ArticleID)
			values (@assID, @artID)
		end

		select @id = @id + 1	--min(ID) from #t where ID > @id
		if @id % 100 = 0
			print @id
	end

-- Assignment_Resource
insert into Assignment_Resource (AssignmentID, UserId, UserRoleID)
select a.ID, tn.UserId, 0
from Assignment a
	join Assignment_TastingEvent ate on a.ID = ate.AssignmentID
	join TastingEvent_TasteNote tetn on ate.TastingEventID = tetn.TastingEventID
	join TasteNote tn on tetn.TasteNoteID = tn.ID
where tn.UserId != 0
group by a.ID, tn.UserId
	
COMMIT TRAN
--ROLLBACK TRAN

drop table #t

print 'Done.'
GO
