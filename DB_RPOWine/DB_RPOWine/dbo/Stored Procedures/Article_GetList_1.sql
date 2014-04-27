-- =============================================
-- Author:		Alex B.
-- Create date: 4/1/2014
-- Description:	Gets List of Articles.
--				Input parameters are used as a filter.
-- =============================================
CREATE PROCEDURE [dbo].[Article_GetList]
	@ID int = NULL, 
	@PublicationID int = NULL, @IssueID int = NULL, @AssignmentID int = NULL,
	@AuthorId int = NULL,
	@Title nvarchar(255) = NULL,
	@ShowRes smallint = 1
	
/*
exec Article_GetList @PublicationID = 1
*/
	
AS
set nocount on

----------------- Checks 
select @Title = nullif(@Title, '')
if @Title is NOT NULL
	select @Title = '%' + ltrim(rtrim(@Title)) + '%'
	
if @PublicationID is NOT NULL and not exists(select * from Publication (nolock) where ID = @PublicationID) begin
	raiserror('Article_GetList:: Publication record with ID=%i does not exist.', 16, 1, @PublicationID)
	RETURN -1
end

if @AuthorId is NOT NULL and not exists(select * from Users (nolock) where UserId = @AuthorId) begin
	raiserror('Article_GetList:: User record with ID=%i does not exist.', 16, 1, @AuthorId)
	RETURN -1
end
----------------- Checks 

create table #f (ID int not null);
if @ID is NOT NULL begin
	insert into #f (ID) 
	values (@ID)
end else begin
	insert into #f (ID) 
	select a.ID
	from Article a (nolock)
		left join Issue_Article ia (nolock) on a.ID = ia.IssueID
		left join Assignment_Article aa (nolock) on a.ID = aa.ArticleID
	where (@PublicationID is NULL or a.PublicationID = @PublicationID)
		and (@AuthorId is NULL or a.AuthorId = @AuthorId)
		and (@Title is NULL or a.Title like @Title)
		and (@IssueID is NULL or ia.IssueID = @IssueID)
		and (@AssignmentID is NULL or aa.AssignmentID = @AssignmentID)
	group by a.ID
end

; with 
st_tn as (
	select ArticleID = atn.ArticleID,
		Cnt = count(*),
		Cnt_Published = sum(case when tn.WF_StatusID > 99 then 1 else 0 end)
	from Article_TasteNote atn (nolock)
		join #f on atn.ArticleID = #f.ID
		join TasteNote tn (nolock) on atn.TasteNoteID = tn.ID
	group by atn.ArticleID
),
st_i as (
	select ArticleID = ia.ArticleID,
		Cnt = count(*),
		Cnt_Published = sum(case when i.WF_StatusID > 99 then 1 else 0 end)
	from Issue_Article ia (nolock)
		join #f on ia.ArticleID = #f.ID
		join Issue i (nolock) on ia.IssueID = i.ID
	group by ia.ArticleID
)
select 
	ID = a.ID,
	PublicationID = a.PublicationID,
	PublicationName = p.Name,
	AuthorId = a.AuthorId,
	AuthorName = isnull(u.FullName, ''),
	Author = a.Author,
	Title = a.Title,
	ShortTitle = a.ShortTitle, 
	Date = a.Date, 
	Notes = a.Notes, 
	MetaTags = a.MetaTags, 
	Event = a.Event, 
	CuisineID = a.CuisineID, 
	CuisineName = c.Name, 
	
	locCountryID = a.locCountryID, 
	locRegionID = a.locRegionID, 
	locLocationID = a.locLocationID, 
	locLocaleID = a.locLocaleID, 
	locSiteID = a.locSiteID, 
	locStateID = a.locStateID, 
	locCityID = a.locCityID,
	Country = lc.Name, Region = lr.Name, Location = ll.Name, 
	Locale = lloc.Name, Site = ls.Name, State = lss.Name, City = lcc.Name,
	locAppellation = coalesce(
		nullif(ls.Name,''), nullif(lloc.name,''), nullif(ll.name,''), nullif(lr.name,''), nullif(lc.name,'')
	),
	
	WF_StatusID = a.WF_StatusID,
	
	oldArticleIdN = a.oldArticleIdN, 
	oldArticleId = a.oldArticleId, 
	oldArticleIdNKey = a.oldArticleIdNKey,
	FileName = a.FileName, 
	Producer = a.Producer, 
	Source = a.Source,	
	Topic = a.Topic, 
	Type = a.Type, 
	Wine_Numbers = a.Wine_Numbers, 
	Wines = a.Wines, 
	Vintage = a.Vintage, 
	Appellation = a.Appellation,
		
	created = a.created, 
	updated = a.updated,
	
	Cnt_TasteNotes = isnull(st_tn.Cnt, 0),
	Cnt_TasteNotesPublished = isnull(st_tn.Cnt_Published, 0),
	Cnt_Issues = isnull(st_i.Cnt, 0),
	Cnt_IssuesPublished = isnull(st_i.Cnt_Published, 0)	
from Article a (nolock)
	join #f on a.ID = #f.ID
	join Publication p (nolock) on a.PublicationID = p.ID
	join Cuisine c (nolock) on a.CuisineID = c.ID
	left join Users u (nolock) on a.AuthorId = u.UserId
	
	join dbo.LocationCountry lc (nolock) on a.locCountryID = lc.ID
	join dbo.LocationRegion lr (nolock) on a.locRegionID = lr.ID
	join dbo.LocationLocation ll (nolock) on a.locLocationID = ll.ID
	join dbo.LocationLocale lloc (nolock) on a.locLocaleID = lloc.ID
	join dbo.LocationSite ls (nolock) on a.locSiteID = ls.ID
	join dbo.LocationState lss (nolock) on a.locStateID = lss.ID
	join dbo.LocationCity lcc (nolock) on a.locCityID = lcc.ID
	
	left join st_tn on a.ID = st_tn.ArticleID
	left join st_i on a.ID = st_i.ArticleID
order by a.Date desc, a.ID
	
drop table #f;

RETURN 1
GO
GRANT EXECUTE
    ON OBJECT::[dbo].[Article_GetList] TO [RP_DataAdmin]
    AS [dbo];

