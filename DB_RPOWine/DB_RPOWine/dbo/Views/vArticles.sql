
CREATE VIEW [dbo].[vArticles]

AS

select 
	ID = a.ID,
	a.FileName,
    PublicationID = a.PublicationID,
    PublicationName = p.Name,
    AuthorId = a.AuthorId,
    AuthorName = u.FullName,
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
	Locale = lloc.Name, Site = ls.Name,
	Appellation = coalesce(
		nullif(ls.Name,''), nullif(lloc.name,''), nullif(ll.name,''), nullif(lr.name,''), nullif(lc.name,'')
	),
		
    a.created,
    a.updated,
    a.WF_StatusID,
    a.oldArticleIdN,
    a.oldArticleId,
    a.oldArticleIdNKey
from Article a (nolock)
	join Publication p (nolock) on a.PublicationID = p.ID
	join Users u (nolock) on a.AuthorId = u.UserId
	join Cuisine c (nolock) on a.CuisineID = c.ID
	
	join dbo.LocationCountry lc on a.locCountryID = lc.ID
	join dbo.LocationRegion lr on a.locRegionID = lr.ID
	join dbo.LocationLocation ll on a.locLocationID = ll.ID
	join dbo.LocationLocale lloc on a.locLocaleID = lloc.ID
	join dbo.LocationSite ls on a.locSiteID = ls.ID
	join dbo.LocationState lss on a.locStateID = lss.ID
	join dbo.LocationCity lcc on a.locCityID = lcc.ID