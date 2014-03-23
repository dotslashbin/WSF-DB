print '---------- Loading Data... ------------'
GO
--print '---------- Deleting Data... ------------'
--GO
--rollback tran
--truncate table Issue_Article
--truncate table Assignment_Article
--delete Article
--DBCC CHECKIDENT (Article, RESEED, 1)
--GO
--select count(*) from RPOWineData.dbo.Articles	--1,387
--select count(*) from Article
--select count(*) from Issue_Article
--select count(*) from Assignment_Article
--GO
--drop table #t
print '---------- Missing Publications & Issues ------------'
GO
--select * from Publication
insert into Publication (PublisherID, Name)
values	(1, 'Wine Buyer''s Guide, 5th Edition, 1999'),
		(2, 'Articles Of Merit'), (2, 'Uncensored and Live')
GO
print '--------- Preparing Data -----------'
GO
; with pa as (
	select 
		Publication = case
			when Filename is NOT NULL and Filename like 'ag[0-9]%.asp' then 'In the Cellar'
			when Filename is NOT NULL and Filename like 'article[0-9]%.asp' then 'Wine Advocate'
			when Filename is NOT NULL and Filename like 'articleofmerit[0-9]%.asp' then 'Articles Of Merit'
			when Filename is NOT NULL and Filename like 'nm[0-9]%.asp' then 'Wine Journal'
			when Filename is NOT NULL and Filename like 'rp[0-9]%.asp' then 'Uncensored and Live'
			else 'Wine Journal'
		end,
		Issue = NULL, Author = a.Author, Title = a.Title,
		ArticleId = null, ArticleIdN = null, ArticleIdNKey = null,
		Country = isnull(a.Country, ''), Region = isnull(a.Region, ''), Location = isnull(a.Appellation, ''),
		Locale = NUll, Site = NULL, State = isnull(a.State,''), City = isnull(a.City,''),
		Cuisine = isnull(a.Cuisine, ''), Date = a.Date, ShortTitle = a.Short_title, IssueDate = null,
		FileName = Filename
	from ArticlesParser.dbo.Articles a
)
select * into #t from (
	select 
		Publication = isnull(a.Publication, ww.Publication),
		Issue = isnull(a.Issue, ww.Issue), 
		Author = a.Source, 
		Title = isnull(a.Title, pa.Title),

		ArticleId = a.ArticleId, ArticleIdN = max(a.idN), ArticleIdNKey = min(a.ArticleIdNKey),
		Country = max(isnull(a.Country, '')), Region = max(isnull(a.Region, '')), Location = max(isnull(a.Location, '')),
		Locale = max(isnull(a.Locale, '')), Site = max(isnull(a.Site, '')), State = max(isnull(pa.State, '')), City = max(isnull(pa.City,'')),
		Cuisine = max(isnull(pa.Cuisine, '')),
		Date = max(isnull(isnull(pa.Date, isnull(a.sourceDate, a.dateUpdated)),'1/1/2000')),
		ShortTitle = max(isnull(pa.ShortTitle, ww.ShortTitle)),
		IssueDate = max(isnull(a.sourceDate, isnull(ww.SourceDate, a.dateUpdated))),
		FileName = 'article' + cast(max(a.ArticleId) as varchar(20)) + '.asp'
	from RPOWineData.dbo.Articles a
		left join (select idN = m.idN, 
			Publication=max(w.Publication), Issue=max(w.Issue), ShortTitle=max(w.ShortTitle), SourceDate=max(w.SourceDate)
			from RPOWineData.dbo.tocMap m
				left join RPOWineData.dbo.Wine w on w.FixedId = m.fixedId
			group by m.idN) ww on a.idN = ww.idN
		left join pa on 'article' + cast(a.ArticleId as varchar(20)) + '.asp' = pa.FileName
	group by isnull(a.Publication, ww.Publication), isnull(a.Issue, ww.Issue), a.Source, isnull(a.Title, pa.Title), a.ArticleId
	UNION
	select pa.Publication, pa.Issue, pa.Author, pa.Title, pa.ArticleId, pa.ArticleIdN, pa.ArticleIdNKey,
		pa.Country, pa.Region, pa.Location, pa.Locale, pa.Site, pa.State, pa.City,
		pa.Cuisine, pa.Date, pa.ShortTitle, pa.IssueDate,
		pa.FileName
	from pa
		left join RPOWineData.dbo.Articles a on 'article' + cast(a.ArticleId as varchar(20)) + '.asp' = pa.FileName
	where a.ArticleId is NULL
) t;
		
alter table #t add
	PubID int null, IssID int null, UserId int null, CuisineID int null,
	locCountryID int null, locRegionID int null, locLocationID int null, locLocaleID int null, 
	locSiteID int null, locStateID int null, locCityID int null
GO

update #t set
	PubID = p.ID,
	IssID = i.ID,
	UserId = u.UserId,
	CuisineID = isnull(cus.ID, 0),
	locCountryID = isnull(lc.ID, 0),
	locRegionID = isnull(lr.ID, 0),
	locLocationID = isnull(ll.ID, 0),
	locLocaleID = isnull(lloc.ID, 0),
	locSiteID = isnull(ls.ID, 0),
	locStateID = isnull(lss.ID, 0),
	locCityID = isnull(lcc.ID, 0)
from #t
	left join Publication p on p.Name = case
		when Publication like '%robertpark%' and Issue not in ('154','174','B1', 'B2') then 'eRobertParker.com'
		when Publication like '%robertpark%' and Issue in ('154','174') then 'Wine Advocate'
		when Publication like '%robertpark%' and Issue in ('B1') then 'Bordeaux Book, 3rd Edition'
		when Publication like '%robertpark%' and Issue in ('B2') then 'Burgundy Book'
		when Publication in ('eRP') then 'eRobertParker.com'
		when Publication in ('Neal Martin’s Wine Journal', 'Wines of the Rhone Valley') then 'Wine Journal'
		when Publication like 'Executive Wine Seminar%' then 'Executive Wine Seminar'
		else Publication
	end
	left join Issue i (nolock) on p.ID = i.PublicationID and i.Title = #t.Issue
	left join Users u on isnull(#t.Author, '') != '' and u.FullName = case
		when #t.Author in ('Robert Parker', 'Robert Parker / Pierre Rovani') then 'Robert M. Parker, Jr.' 
		when #t.Author = 'Jay Miller' then 'Jay S Miller' 
		when #t.Author = 'Lisa Perrotti-Brown & Neal Martin' then 'Lisa Perrotti-Brown'
		else #t.Author 
	end
	left join Cuisine cus on isnull(#t.Cuisine, '') = cus.Name
	left join LocationCountry lc on isnull(#t.Country, '') = lc.Name
	left join LocationRegion lr on isnull(#t.Region, '') = lr.Name
	left join LocationLocation ll on isnull(#t.Location, '') = ll.Name
	left join LocationLocale lloc on isnull(#t.Locale, '') = lloc.Name
	left join LocationSite ls on isnull(#t.Site, '') = ls.Name
	left join LocationState lss on isnull(#t.State, '') = lss.Name
	left join LocationCity lcc on isnull(#t.City, '') = lcc.Name

print '----------- Loading Data --------------'
-- for TWA and eRP ONLY, other publications do not have issues.
insert into Issue(PublicationID, Title, CreatedDate, PublicationDate)
select PubID = #t.PubID, 'Lost & Found', max(isnull(IssueDate, '1/1/2000')), max(isnull(IssueDate, '1/1/2000'))
from #t
	join Publication p on #t.PubID = p.ID and p.Name in ('eRobertParker.com','Wine Advocate')
	left join Issue i on #t.PubID = i.PublicationID and i.Title = 'Lost & Found'
where IssID is NULL and i.ID is NULL
group by PubID

print '---------- Articles ------------'
GO
--select isnull(Author, ''), count(*) from #t where UserId is NULL and isnull(Author, '') != '' group by isnull(Author, '')
insert into Article (PublicationID, AuthorId, Author, Title, ShortTitle, Date, Notes, MetaTags, 
	Event, CuisineID, 
	locCountryID, locRegionID, locLocationID, locLocaleID, locSiteID, locStateID, locCityID,
	WF_StatusID, 
	oldArticleIdN, oldArticleId, oldArticleIdNKey, FileName,
	Producer, Source, Topic, Type, Wine_Numbers, Wines, Vintage, Appellation)
select #t.PubID, isnull(#t.UserId, 0), isnull(#t.Author, ''), #t.Title, isnull(#t.ShortTitle, pa.Short_title), #t.Date, pa.Body, '', 
	pa.Event, #t.CuisineID, 
	#t.locCountryID, #t.locRegionID, #t.locLocationID, #t.locLocaleID, #t.locSiteID, #t.locStateID, #t.locCityID,
	100, 
	#t.ArticleIdN, #t.ArticleId, #t.ArticleIdNKey, #t.FileName,
	pa.Producer, pa.Source, pa.Topic, pa.Type, pa.Wine_numbers, pa.Wines, pa.Vintage, pa.Appellation
from #t
	left join ArticlesParser.dbo.Articles pa on #t.FileName = pa.Filename

print '---------- Article Links ------------'
GO
--select count(*) from #t where isnull(IssID, 0)>0
insert into Issue_Article (IssueID, ArticleID)
select distinct isnull(#t.IssID, i.ID), a.ID
from #t
	join Article a (nolock) on #t.PubID = a.PublicationID and isnull(#t.UserId, 0) = a.AuthorId 
		and #t.Title=a.Title and datediff(day,#t.Date,a.Date) = 0
		and isnull(#t.FileName, '') = isnull(a.FileName, '') 
		and isnull(#t.ArticleIdN, 0) = isnull(a.oldArticleIdN, 0) --and isnull(#t.ArticleIdNKey, 0) = isnull(a.oldArticleIdNKey, 0)
	left join Issue i (nolock) on a.PublicationID = i.PublicationID and i.Title = 'Lost & Found'
where isnull(#t.IssID, 0) > 0 or i.ID is NOT NULL --and a.ID is NULL
GO

insert into Article_TasteNote(ArticleID, TasteNoteID)
select a.ID, tn.ID
from Article a (nolock)
	join RPOWineData.dbo.tocMap m (nolock) on m.idN = a.oldArticleIdN
	join RPOWineData.dbo.Wine w on w.FixedId = m.fixedId
	join TasteNote tn (nolock) on w.Idn = tn.oldIdn
where a.oldArticleIdN is NOT NULL and tn.oldIdn is NOT NULL
GO

-- check! There is should be no records for publication eRP and TWA!
select p.Name, count(*)
from Article a
	join Publication p on a.PublicationID = p.ID
	left join Issue_Article ia on a.ID = ia.ArticleID
where ia.IssueID is NULL
group by p.Name
order by p.Name

drop table #t
GO