-- =============================================
-- Author:		Alex B.
-- Create date: 4/1/2014
-- Description:	Gets List of Articles.
--				Input parameters are used as a filter.
-- =============================================
CREATE PROCEDURE [dbo].[Article_GetList]
	@ID int = NULL, 
	@PublicationID int = NULL,
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

; with 
st_tn as (
	select ArticleID = atn.ArticleID,
		Cnt = count(*),
		Cnt_Published = sum(case when tn.WF_StatusID > 99 then 1 else 0 end)
	from Article_TasteNote atn (nolock)
		join TasteNote tn (nolock) on atn.TasteNoteID = tn.ID
	group by atn.ArticleID
),
st_i as (
	select ArticleID = ia.ArticleID,
		Cnt = count(*),
		Cnt_Published = sum(case when i.WF_StatusID > 99 then 1 else 0 end)
	from Issue_Article ia (nolock)
		join Issue i (nolock) on ia.IssueID = i.ID
	group by ia.ArticleID
)
select 
	ID = a.ID,
	PublicationID = a.PublicationID,
	PublicationName = p.Name,
	AuthorId = a.AuthorId,
	AuthorName = isnull(u.FullName, ''),
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
	join Publication p (nolock) on a.PublicationID = p.ID
	join Cuisine c (nolock) on a.CuisineID = c.ID
	left join Users u (nolock) on a.AuthorId = u.UserId
	
	join dbo.LocationCountry lc on a.locCountryID = lc.ID
	join dbo.LocationRegion lr on a.locRegionID = lr.ID
	join dbo.LocationLocation ll on a.locLocationID = ll.ID
	join dbo.LocationLocale lloc on a.locLocaleID = lloc.ID
	join dbo.LocationSite ls on a.locSiteID = ls.ID
	join dbo.LocationState lss on a.locStateID = lss.ID
	join dbo.LocationCity lcc on a.locCityID = lcc.ID
	
	left join st_tn on a.ID = st_tn.ArticleID
	left join st_i on a.ID = st_i.ArticleID
where a.ID = isnull(@ID, a.ID)
	and (@PublicationID is NULL or a.PublicationID = @PublicationID)
	and (@AuthorId is NULL or a.AuthorId = @AuthorId)
	and (@Title is NULL or a.Title like @Title)
order by a.Date desc, a.ID
	
RETURN 1
GO
GRANT EXECUTE
    ON OBJECT::[dbo].[Article_GetList] TO [RP_DataAdmin]
    AS [dbo];

