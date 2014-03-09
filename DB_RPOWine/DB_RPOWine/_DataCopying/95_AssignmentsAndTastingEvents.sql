--select top 20 * from TasteNote			-- 278,788
--select count(*) from TasteNote			-- 278,788
--select count(*) from Issue_TasteNote	-- 278,785
--select count(*) from TastingEvent
--select count(*) from TastingEvent_TasteNote
--------------------------------------
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
--select count(*) from Assignment
--select count(*) from TastingEvent
--select count(*) from TastingEvent_TasteNote

--select count(*) from Article
--select count(*) from Issue_Article
--select count(*) from Assignment_Article
--GO
print '---------- Loading Data... ------------'
GO
select distinct
	PublicationID = p.ID,
	IssueID = itn.IssueID, 
	AuthorId = tn.UserId, 
	AssTitle = p.Name + '. ' + i.Title + '. ' + isnull(u.FullName, ''), 
	AssDeadline = i.PublicationDate,
	WineProducerID = vn.ProducerID,
	WineProducerName = wp.NameToShow,
	AssignmentID = 0, TastingEventID = 0
into #t
from TasteNote tn (nolock)
	join Issue_TasteNote itn (nolock) on tn.ID = itn.TasteNoteID
	join Issue i (nolock) on itn.IssueID = i.ID
	join Publication p (nolock) on i.PublicationID = p.ID
	join Users u (nolock) on tn.UserId = u.UserId
	join Wine_N wn (nolock) on tn.Wine_N_ID = wn.ID
	join Wine_VinN vn (nolock) on wn.Wine_VinN_ID = vn.ID
	join WineProducer wp (nolock) on vn.ProducerID = wp.ID
order by PublicationID, IssueID, AssTitle
--select * from #t

alter table #t add ID int not null identity(1,1);

declare @id int = 0, 
	@prevKey varchar(100) = '', @Key varchar(100) = '', 
	@issueID int, @assID int, @teID int, @uRoleID int = 0

set xact_abort on
set nocount on
--BEGIN TRAN

	select @id = 1
	while exists(select * from #t where ID = @id) begin	
		select @Key = AssTitle, @issueID = IssueID from #t where ID = @id
		
		if (@prevKey != @Key) begin
			select @prevKey = @Key
			-- Assignment
			insert into Assignment (IssueID, AuthorId, Title, Deadline, Notes, WF_StatusID)
			select #t.IssueID, #t.AuthorId, #t.AssTitle, #t.AssDeadline, '', 100 
			from #t 
			where #t.ID = @id
			select @assID = scope_identity()
			
			update #t set AssignmentID = @assID where ID = @id
		end
		
		if isnull(@assID, 0) > 0 begin
			-- Flights == TastingEvents
			insert into TastingEvent (UserId, Title, StartDate, EndDate,
				Location, locCountryID, locRegionID, locLocationID, locLocaleID, locSiteID,
				Notes, SortOrder, WF_StatusID)
			select 
				UserId=isnull(AuthorId,0), 
				Title = WineProducerName,
				StartDate=NULL, EndDate=NULL,
				Location = ltrim(rtrim(lc.Name + ' ' + lr.Name + ' ' + ll.Name)),
				locCountryID=wp.locCountryID, locRegionID=wp.locRegionID, locLocationID=wp.locLocationID, locLocaleID=wp.locLocaleID, locSiteID=0,
				Notes=NULL, SortOrder=0, WF_StatusID=100
			from #t 
				join WineProducer wp (nolock) on #t.WineProducerID = wp.ID
				join LocationCountry lc (nolock) on wp.locCountryID = lc.ID
				join LocationRegion lr (nolock) on wp.locRegionID = lr.ID
				join LocationLocation ll (nolock) on wp.locLocationID = ll.ID
			where #t.ID = @id
			select @teID = scope_identity()

			update #t set AssignmentID = @assID, TastingEventID = @teID where ID = @id
		end
		
		select @id = @id + 1
		if @id % 100 = 0
			print @id
	end -- while

	-- Assignments
	select @uRoleID = min(ID) from UserRoles
	if (@uRoleID is NULL) begin
		set identity_insert UserRoles on
		insert into UserRoles(ID, Name) values (0, '')
		set identity_insert UserRoles off
		set @uRoleID = 0
	end

	insert into Assignment_Resource (AssignmentID, UserId, UserRoleID)
	select distinct AssignmentID, AuthorId, @uRoleID
	from #t where AssignmentID > 0

	insert into Assignment_ResourceD (AssignmentID, TypeID, Deadline)
	select distinct AssignmentID, 0, AssDeadline
	from #t where AssignmentID > 0

	-- TastingEvents
	insert into Assignment_TastingEvent(AssignmentID, TastingEventID)
	select distinct AssignmentID, TastingEventID
	from #t where AssignmentID > 0 and TastingEventID > 0

	insert into TastingEvent_TasteNote (TastingEventID, TasteNoteID)
	select #t.TastingEventID, tn.ID
	from #t
		join Wine_VinN vn (nolock) on vn.ProducerID = #t.WineProducerID
		join Wine_N wn (nolock) on wn.Wine_VinN_ID = vn.ID
		join TasteNote tn (nolock) on tn.Wine_N_ID = wn.ID and #t.AuthorId = tn.UserId
		join Issue_TasteNote itn (nolock) on tn.ID = itn.TasteNoteID and #t.IssueID = itn.IssueID
	where #t.TastingEventID > 0

	-- Articles
	; with a as (
		select 
			a.ArticleId, ArticleIdN = a.idN, a.ArticleIdNKey,
			Country = isnull(a.Country, ''), Region = isnull(a.Region, ''), Location = isnull(a.Location, ''),
			a.Publication, a.Issue, 
			Author = a.Source, 
			Date = isnull(a.sourceDate, a.dateUpdated),
			Title = a.Title,
			ShortTitle = max(w.ShortTitle)
		from RPOWineData.dbo.Articles a
			left join RPOWineData.dbo.tocMap m on a.idN = m.idN
			left join RPOWineData.dbo.Wine w on w.FixedId = m.fixedId
		group by a.ArticleId, a.idN, a.ArticleIdNKey,
			isnull(a.Country, ''), isnull(a.Region, ''), isnull(a.Location, ''), a.Publication, a.Issue, 
			a.Source, isnull(a.sourceDate, a.dateUpdated),
			a.Title
	)
	insert into Article (AuthorId, Title, Date, Notes, MetaTags, WF_StatusID, 
		oldArticleIdN, oldArticleId, oldArticleIdNKey)
	select isnull(u.UserId, 0), a.Title, a.Date, '', '', 100,
		a.ArticleIdN, a.ArticleId, a.ArticleIdNKey
	from a
		join Publication p (nolock) on a.Publication = p.Name
		join Issue i (nolock) on i.PublicationID = p.ID and a.Issue = i.Title
		left join LocationCountry lc (nolock) on a.Country = lc.Name
		left join LocationRegion lr (nolock) on a.Region = lr.Name
		left join LocationLocation ll (nolock) on a.Location = ll.Name
		left join Users u (nolock) on isnull(a.Author, '') != '' and a.Author = u.FullName

	insert into Assignment_Article (AssignmentID, ArticleID)
	select distinct 
		AssignmentID = ate.AssignmentID, 
		ArticleID = a.ID
	from Article a
		join RPOWineData.dbo.tocMap m on a.oldArticleIdN = m.idN
		join TasteNote tn on m.fixedId = tn.oldFixedId and a.AuthorId = tn.UserId
		join TastingEvent_TasteNote tetn on tn.ID = tetn.TasteNoteID
		join Assignment_TastingEvent ate on tetn.TastingEventID = ate.TastingEventID
	where isnull(tn.oldFixedId, 0) > 0
	order by ArticleID
	
	insert into Issue_Article (IssueID, ArticleID)
	select i.ID, a.ID
	from Article a
		join RPOWineData.dbo.Articles s on a.oldArticleIdN = s.idN
		join Publication p on s.Publication = p.Name
		join Issue i on s.Issue = i.Title and p.ID = i.PublicationID
		
--COMMIT TRAN
--ROLLBACK TRAN

drop table #t

print '--- Done. ---'
GO

/*
select top 2000 
	a.Title, ST = max(w.ShortTitle)
from RPOWineData.dbo.Articles a
	join RPOWineData.dbo.tocMap m on a.idN = m.idN
	join RPOWineData.dbo.Wine w on w.FixedId = m.fixedId
where isnull(a.Title, '') != '' and isnull(w.ShortTitle, '') != ''
	and isnull(a.Title, '') != isnull(w.ShortTitle, '')
group by a.Title
*/