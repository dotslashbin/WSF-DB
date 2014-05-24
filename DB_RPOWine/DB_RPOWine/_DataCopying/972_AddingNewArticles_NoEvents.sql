---- Add Cuisine if neccessary ----
; with r as (
	select Cuisine = replace(Cuisine, '`',''), cnt = count(*) from ArticleParser.dbo.Articles group by Cuisine --order by Cuisine
)
insert into Cuisine (Name)
select Cuisine
from r	
	left join Cuisine c on r.Cuisine = c.Name
where c.ID is NULL
	and len(isnull(Cuisine, '')) > 3
;
---------------- Articles -----------------------------------
; with r as (
	select 
		PublicationID = isnull(a.PublicationID, isnull(p.ID, 0)), 
		Publication = case
			when pa.Filename is NOT NULL and pa.Filename like 'ag[0-9]%.asp' then 'In the Cellar'
			when pa.Filename is NOT NULL and pa.Filename like 'article[0-9]%.asp' then 'Wine Advocate'
			when pa.Filename is NOT NULL and pa.Filename like 'articleofmerit[0-9]%.asp' then 'Articles Of Merit'
			when pa.Filename is NOT NULL and pa.Filename like 'nm[0-9]%.asp' then 'Wine Journal'
			when pa.Filename is NOT NULL and pa.Filename like 'rp[0-9]%.asp' then 'Uncensored and Live'
			else 'Wine Journal'
		end,
		FileName = isnull(a.FileName, pa.FileName),
		AuthorId = isnull(a.AuthorId, isnull(u.UserId, 0)),
		Author = isnull(a.Author, pa.Author),
		Title = isnull(a.Title, pa.Title),
		ShortTitle = isnull(a.ShortTitle, pa.Short_title), 
		Date = isnull(a.Date, pa.Date),
		Notes = isnull(pa.Body, a.Notes),
		Event = isnull(pa.Event, a.Event),
		CuisineID = isnull(a.CuisineID, isnull(cus.ID, 0)), 
		locCountryID = isnull(a.locCountryID, isnull(lc.ID, 0)), 
		locRegionID = isnull(a.locRegionID, isnull(lr.ID, 0)), 
		locLocationID = isnull(a.locLocationID, 0), 
		locLocaleID = isnull(a.locLocaleID, 0),
		locSiteID = isnull(a.locSiteID, 0), 
		locStateID = isnull(a.locStateID, isnull(lss.ID, 0)), 
		locCityID = isnull(a.locCityID, isnull(lcc.ID, 0)),
		Producer = isnull(pa.Producer, a.Producer), 
		Source = isnull(pa.Source, a.Source), 
		Topic = isnull(pa.Topic, a.Topic), 
		Type = isnull(pa.Type, a.Type), 
		Wine_Numbers = isnull(pa.Wine_numbers, a.Wine_Numbers), 
		Wines = isnull(pa.Wines, a.Wines), 
		Vintage = isnull(pa.Vintage, a.Vintage), 
		Appellation = isnull(pa.Appellation, a.Appellation),
		--oldArticleId = isnull(a.oldArticleId, pa.ArticleID),
		AID = a.ID
	from ArticleParser.dbo.Articles pa 
		left join Article a on a.FileName = pa.Filename
		
		left join Publication p on p.Name = case
			when Publication like '%robertpark%' then 'eRobertParker.com'
			when Publication in ('eRP') then 'eRobertParker.com'
			when Publication in ('Neal Martin’s Wine Journal', 'Wines of the Rhone Valley') then 'Wine Journal'
			when Publication like 'Executive Wine Seminar%' then 'Executive Wine Seminar'
			else case
				when pa.Filename is NOT NULL and pa.Filename like 'ag[0-9]%.asp' then 'In the Cellar'
				when pa.Filename is NOT NULL and pa.Filename like 'article[0-9]%.asp' then 'Wine Advocate'
				when pa.Filename is NOT NULL and pa.Filename like 'articleofmerit[0-9]%.asp' then 'Articles Of Merit'
				when pa.Filename is NOT NULL and pa.Filename like 'nm[0-9]%.asp' then 'Wine Journal'
				when pa.Filename is NOT NULL and pa.Filename like 'rp[0-9]%.asp' then 'Uncensored and Live'
				else 'Wine Journal'
			end
		end
		left join Users u on isnull(pa.Author, '') != '' and u.FullName = case
			when pa.Author in ('Robert Parker', 'Robert Parker / Pierre Rovani') then 'Robert M. Parker, Jr.' 
			when pa.Author = 'Jay Miller' then 'Jay S Miller' 
			when pa.Author = 'Lisa Perrotti-Brown & Neal Martin' then 'Lisa Perrotti-Brown'
			when pa.Author = 'Martin, Neal' then 'NEAL MARTIN'
			else pa.Author 
		end
		left join Cuisine cus on isnull(replace(pa.Cuisine, '`',''), '') = cus.Name
		left join LocationCountry lc on isnull(pa.Country, '') = lc.Name
		left join LocationRegion lr on isnull(pa.Region, '') = lr.Name
		left join LocationState lss on isnull(pa.State, '') = lss.Name
		left join LocationCity lcc on isnull(pa.City, '') = lcc.Name
	where len(isnull(pa.FileName, '')) > 2
)
select * into #t
from r;

--select max(len(Appellation)) from #t

merge Article as t
using (
	select *
	from #t
) as s on t.ID = s.AID
when matched then
	UPDATE set 
		PublicationID = s.PublicationID,
		FileName = s.FileName,
		AuthorId = s.AuthorId,
		Author = s.Author,
		Title = s.Title,
		ShortTitle = s.ShortTitle, 
		Date = s.Date,
		Notes = s.Notes,
		Event = s.Event,
		CuisineID = s.CuisineID,
		locCountryID = s.locCountryID,
		locRegionID = s.locRegionID,
		locLocationID = s.locLocationID,
		locLocaleID = s.locLocaleID,
		locSiteID = s.locSiteID,
		locStateID = s.locStateID,
		locCityID = s.locCityID,
		Producer = s.Producer,
		Source = s.Source,
		Topic = s.Topic,
		Type = s.Type,
		Wine_Numbers = s.Wine_numbers,
		Wines = s.Wines,
		Vintage = s.Vintage,
		Appellation = s.Appellation,
		--oldArticleId = s.oldArticleId,
		updated = getdate()
when not matched by target then
	INSERT (PublicationID, FileName, AuthorId, Author, Title, ShortTitle, Date, Notes, Event, CuisineID,
		locCountryID, locRegionID, locLocationID, locLocaleID, locSiteID, locStateID, locCityID,
		Producer, Source, Topic, Type, Wine_Numbers, Wines, Vintage, Appellation, --oldArticleId, 
		created)
	values (s.PublicationID, s.FileName, s.AuthorId, s.Author, s.Title, s.ShortTitle, s.Date, s.Notes, s.Event, s.CuisineID,
		s.locCountryID, s.locRegionID, s.locLocationID, s.locLocaleID, s.locSiteID, s.locStateID, s.locCityID,
		s.Producer, s.Source, s.Topic, s.Type, s.Wine_Numbers, s.Wines, s.Vintage, s.Appellation, --s.oldArticleId, 
		getdate());

drop table #t;

print 'Done.'
GO
