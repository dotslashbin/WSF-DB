--select top 20 * from TasteNote			-- 278,788
--select count(*) from TasteNote			-- 278,788
--select count(*) from Issue_TasteNote	-- 278,785
--select count(*) from TastingEvent
--select count(*) from TastingEvent_TasteNote
--------------------------------------
--print '---------- Deleting Data... ------------'
--GO
--rollback tran
--truncate table Issue_Article
--truncate table Assignment_TastingEvent
--truncate table TastingEvent_TasteNote
--truncate table Assignment_Article
--truncate table Assignment_Resource
--truncate table Assignment_ResourceD
--truncate table Article_TasteNote
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
/*
select distinct
	PublicationID = p.ID,
	IssueID = itn.IssueID, 
	AuthorId = tn.UserId, 
	AssTitle = p.Name + '. ' + i.Title + '. ' + isnull(u.FullName, ''), 
	AssDeadline = i.PublicationDate,
	WineProducerID = vn.ProducerID,
	WineProducerName = wp.NameToShow,
	AssignmentID = 0, TastingEventID = 0, ArticleID = 0
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
*/
; with ttn as (
	select distinct
		PublicationID = p.ID,
		IssueID = itn.IssueID, 
		AuthorId = tn.UserId, 
		AssTitle = p.Name + '. ' + i.Title + '. ' + isnull(u.FullName, ''), 
		AssDeadline = i.PublicationDate,
		WineProducerID = vn.ProducerID,
		WineProducerName = wp.NameToShow,
		AssignmentID = 0, TastingEventID = 0, ArticleID = 0
	from TasteNote tn (nolock)
		join Issue_TasteNote itn (nolock) on tn.ID = itn.TasteNoteID
		join Issue i (nolock) on itn.IssueID = i.ID
		join Publication p (nolock) on i.PublicationID = p.ID
		join Users u (nolock) on tn.UserId = u.UserId
		join Wine_N wn (nolock) on tn.Wine_N_ID = wn.ID
		join Wine_VinN vn (nolock) on wn.Wine_VinN_ID = vn.ID
		join WineProducer wp (nolock) on vn.ProducerID = wp.ID
		
		left join (
			select atn.TasteNoteID
			from Article_TasteNote atn 
				join Article art on atn.ArticleID = art.ID
			) f on tn.ID = f.TasteNoteID
	where f.TasteNoteID is NULL
),
art as (
	select
		PublicationID = a.PublicationID,
		IssueID = ia.IssueID, 
		AuthorId = a.AuthorId, 
		AssTitle = p.Name + '. ' + a.Title + '. ' + isnull(u.FullName, ''), 
		AssDeadline = case when a.Date != '1/1/2000' then a.Date else isnull(ww.Date, a.Date) end,
		WineProducerID = isnull(wp.ID,0),
		WineProducerName = isnull(nullif(a.Producer,''), isnull(ww.WineProducer, isnull(nullif(a.Event, ''), a.Title))),
		AssignmentID = 0, TastingEventID = 0, ArticleID = a.ID
	from Article a (nolock)
		join Publication p (nolock) on a.PublicationID = p.ID
		join Issue_Article ia (nolock) on a.ID = ia.ArticleID
		join Issue i (nolock) on ia.IssueID = i.ID
		join Users u (nolock) on a.AuthorId = u.UserId
		left join (
			select idN = m.idN, WineProducer=w.Producer, Date = isnull(w.sourceDate, w.DateUpdated)
			from RPOWineDataD.dbo.tocMap m
				join RPOWineDataD.dbo.Wine w on w.FixedId = m.fixedId
			--group by m.idN
			) ww on a.oldArticleIdN = ww.idN
		left join WineProducer wp (nolock) on ww.WineProducer = wp.Name
)
select PublicationID, IssueID, AuthorId, AssTitle, AssDeadline=max(AssDeadline), WineProducerID, WineProducerName,
		AssignmentID, TastingEventID, ArticleID = max(ArticleID)
into #t 
from (
	select PublicationID, IssueID, AuthorId, AssTitle, AssDeadline,	WineProducerID, WineProducerName,
		AssignmentID, TastingEventID, ArticleID
	from art
	UNION 
	select PublicationID, IssueID, AuthorId, AssTitle, AssDeadline,	WineProducerID, WineProducerName,
		AssignmentID, TastingEventID, ArticleID
	from ttn
) a 
-- TEST
--where IssueID in (34,302)	-- (251,289)	(34,302)
group by PublicationID, IssueID, AuthorId, AssTitle, WineProducerID, WineProducerName,
		AssignmentID, TastingEventID
order by PublicationID, IssueID, AssTitle, WineProducerName
;

-----------------------
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
			insert into TastingEvent (Title, Location, Notes)
			select 
				--UserId=isnull(AuthorId,0), 
				Title = WineProducerName,
				--StartDate=NULL, EndDate=NULL,
				Location = ltrim(rtrim(lc.Name + ' ' + lr.Name + ' ' + ll.Name)),
				--locCountryID=wp.locCountryID, locRegionID=wp.locRegionID, locLocationID=wp.locLocationID, locLocaleID=wp.locLocaleID, locSiteID=0,
				Notes=NULL --, SortOrder=0, WF_StatusID=100
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
	select AssignmentID, 0, AssDeadline=max(AssDeadline)
	from #t where AssignmentID > 0
	group by AssignmentID

	-- TastingEvents
	insert into Assignment_TastingEvent(AssignmentID, TastingEventID)
	select distinct AssignmentID, TastingEventID
	from #t where AssignmentID > 0 and TastingEventID > 0

	-- based on articles first
	insert into TastingEvent_TasteNote (TastingEventID, TasteNoteID)
	select #t.TastingEventID, tn.ID
	from #t
		join Wine_VinN vn (nolock) on vn.ProducerID = #t.WineProducerID
		join Wine_N wn (nolock) on wn.Wine_VinN_ID = vn.ID
		join TasteNote tn (nolock) on tn.Wine_N_ID = wn.ID and #t.AuthorId = tn.UserId
		join Issue_TasteNote itn (nolock) on tn.ID = itn.TasteNoteID and #t.IssueID = itn.IssueID
		join Article_TasteNote atn (nolock) on #t.ArticleID = atn.ArticleID and atn.TasteNoteID = tn.ID
		left join TastingEvent_TasteNote tetn on tetn.TasteNoteID = tn.ID
	where #t.TastingEventID > 0 and tetn.TasteNoteID is NULL
	
	-- add those that do not have link with articles
	insert into TastingEvent_TasteNote (TastingEventID, TasteNoteID)
	select #t.TastingEventID, tn.ID
	from #t
		join Wine_VinN vn (nolock) on vn.ProducerID = #t.WineProducerID
		join Wine_N wn (nolock) on wn.Wine_VinN_ID = vn.ID
		join TasteNote tn (nolock) on tn.Wine_N_ID = wn.ID and #t.AuthorId = tn.UserId
		join Issue_TasteNote itn (nolock) on tn.ID = itn.TasteNoteID and #t.IssueID = itn.IssueID
		left join Article_TasteNote atn (nolock) on #t.ArticleID = atn.ArticleID and atn.TasteNoteID = tn.ID
		left join TastingEvent_TasteNote tetn on tetn.TasteNoteID = tn.ID
	where #t.TastingEventID > 0 and tetn.TasteNoteID is NULL and atn.ArticleID is NULL

	-- the rest of TasteNotes from Articles
	--insert into TastingEvent_TasteNote (TastingEventID, TasteNoteID)
	--select distinct te.TEID, atn.TasteNoteID
	--from Assignment ass
	--	join Assignment_Article assa on ass.ID = assa.AssignmentID
	--	join Article_TasteNote atn on assa.ArticleID = atn.ArticleID
	--	join (select AssignmentID, TEID = max(ate.TastingEventID) from Assignment_TastingEvent ate group by ate.AssignmentID) te
	--		on ass.ID = te.AssignmentID
	--	left join TastingEvent_TasteNote tetn on te.TEID = tetn.TastingEventID and atn.TasteNoteID = tetn.TasteNoteID
	--where tetn.TasteNoteID is NULL

	-- Articles
	insert into Assignment_Article (AssignmentID, ArticleID)
	select distinct #t.AssignmentID, #t.ArticleID
	from #t
	where #t.AssignmentID > 0 and #t.ArticleID > 0

--COMMIT TRAN
--ROLLBACK TRAN

drop table #t

print '--- Done. ---'
GO

/* ------------ check ----------
select * from #t where WineProducerID = 0
select * from Article where ID in (226, 1016)
select * from RPOWineDataD..Articles where ArticleIdNKey in (294, -99900051)
select * from Assignment where ID = 481
select * from Assignment_Article where AssignmentID = 481 
select * from Assignment_TastingEvent where AssignmentID = 481 
select * from Assignment_TasteNote where AssignmentID = 481 
select * from TastingEvent_TasteNote where TastingEventID in (2790,2791)
*/

/* ---- Basic Stats by Issue
--- Articles
; with i as (
	select * from Issue where Title = '210'
)
select TasteNotesNumber = atn.cnt, *
from Article a
	join Issue_Article ia on ia.ArticleID = a.ID
	join i on ia.IssueID = i.ID
	left join (select ArticleID, cnt=count(*) from Article_TasteNote group by ArticleID) atn on a.ID = atn.ArticleID
--------------------	
--- Assignments
; with i as (
	select * from Issue where Title = '210'
)
select ass.ID, ass.IssueID, ass.AuthorId, Author = u.FullName, ass.Title, ass.Deadline,
	Num_Articles = isnull(asa.cnt, 0),
	Num_TastingEvents = isnull(ast.cnt, 0),
	Num_TasteNotes = isnull(asn.cnt, 0)
from Assignment ass
	join i on ass.IssueID = i.ID
	join Users u on ass.AuthorId = u.UserId

	left join (select AssignmentID, cnt=count(*) from Assignment_Article group by AssignmentID) asa on ass.ID = asa.AssignmentID
	left join (select AssignmentID, cnt=count(*) from Assignment_TastingEvent group by AssignmentID) ast on ass.ID = ast.AssignmentID
	left join (select AssignmentID, cnt=count(*) 
		from Assignment_TastingEvent ate
			join TastingEvent_TasteNote ttn on ate.TastingEventID = ttn.TastingEventID
		group by AssignmentID) asn on ass.ID = asn.AssignmentID

----- Taste Notes that are not linked to Articles
select tn.*, AssID = ass.ID, TEID = tetn.TastingEventID
from TasteNote tn
	join TastingEvent_TasteNote tetn on tetn.TasteNoteID = tn.ID
	join Assignment_TastingEvent ate on ate.TastingEventID = tetn.TastingEventID
	join Assignment ass on ate.AssignmentID = ass.ID
	join Assignment_Article aa on ate.AssignmentID = aa.AssignmentID
	left join Article_TasteNote atn on aa.ArticleID = atn.ArticleID and atn.TasteNoteID = tn.ID
where ass.IssueID in (251,289) and atn.ArticleID is NULL

------ Check TasteNote that came not from an article

*/
/*
select * from Assignment where ID = 1371
select * from TastingEvent where ID = 16472
select * from Assignment_Article where AssignmentID = 1371
select * from Article where ID in (1579,1582)
select *
from TasteNote tn
	join vWineDetails w on tn.Wine_N_ID = w.Wine_N_ID
where tn.ID = 93778
select * from Article_TasteNote where TasteNoteID = 93778
select * from RPOWineDataD.dbo.tocMap where fixedId = 382987

delete TastingEvent_TasteNote where TasteNoteID in (
	select tn.ID 
	from TasteNote tn
	where tn.IssueID in (251,289) 
) -- 93778
*/