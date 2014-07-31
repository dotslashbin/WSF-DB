--article database update xxx		[=]
CREATE procedure [dbo].[updateArticleFromRpoWineData] 
as begin
 
set nocount on
 
--------------------------------------------------------------------------------------
-- Update New Article Table from old RpoWineData
--------------------------------------------------------------------------------------
 
 
insert into articleMaster(pubN,pubDate,issue,shortTitle,pages,tasterN,articleId,clumpName,_x_articleIdnKey)
	select pubN,pubDate,issue,shortTitle,pages,tasterN,articleId,clumpName,_x_articleIdnKey
		from vArticleMasterFromRpoWineData a
		where not exists
			(select *
				from articleMaster
				where 
					(pubN is null and a.pubN is not null) or (pubN is not null and a.pubN is null) or (pubN <> a.pubN)
					or (pubDate is null and a.pubDate is not null) or (pubDate is not null and a.pubDate is null) or (pubDate <> a.pubDate)
					or (issue is null and a.issue is not null) or (issue is not null and a.issue is null) or (issue <> a.issue)
					or (pages is null and a.pages is not null) or (pages is not null and a.pages is null) or (pages <> a.pages)
					or (tasterN is null and a.tasterN is not null) or (tasterN is not null and a.tasterN is null) or (tasterN <> a.tasterN)
					or (articleId is null and a.articleId is not null) or (articleId is not null and a.articleId is null) or (articleId <> a.articleId)
					or (clumpName is null and a.clumpName is not null) or (clumpName is not null and a.clumpName is null) or (clumpName <> a.clumpName)
					or (_x_articleIdnKey is null and a._x_articleIdnKey is not null) or (_x_articleIdnKey is not null and a._x_articleIdnKey is null) or (_x_articleIdnKey <> a._x_articleIdnKey)
				)
 
insert into articleMaster(pubN,pubDate,issue,pages,tasterN,articleId,_x_articleIdnKey)
	select pubN,pubDate,issue,pages,tasterN,articleId,_x_articleIdnKey
		from vArticleMasterFromArticleOld a
		where not exists
			(select *
				from articleMaster
				where 
					(pubN is null and a.pubN is not null) or (pubN is not null and a.pubN is null) or (pubN <> a.pubN)
					or (pubDate is null and a.pubDate is not null) or (pubDate is not null and a.pubDate is null) or (pubDate <> a.pubDate)
					or (issue is null and a.issue is not null) or (issue is not null and a.issue is null) or (issue <> a.issue)
					or (pages is null and a.pages is not null) or (pages is not null and a.pages is null) or (pages <> a.pages)
					or (tasterN is null and a.tasterN is not null) or (tasterN is not null and a.tasterN is null) or (tasterN <> a.tasterN)
					or (articleId is null and a.articleId is not null) or (articleId is not null and a.articleId is null) or (articleId <> a.articleId)
					or (_x_articleIdnKey is null and a._x_articleIdnKey is not null) or (_x_articleIdnKey is not null and a._x_articleIdnKey is null) or (_x_articleIdnKey <> a._x_articleIdnKey)
				)
 
update a set a.title = b.title
	from articleMaster a
		join 
			(select pubN, pages, articleId, max(title) title
				from vArticleMasterFromArticleOld
				group by pubN, pages, articleId
				) b
			on 
				a.pubN = b.pubN
				and a.pages = b.pages
				and a.articleId = b.articleid
	where (a.title is null and b.title is not null) or (a.title is not null and b.title is null) or (a.title <> b.title)
 
update articleMaster set joinA = dbo.getJoinA(pubN, pubDate, issue, pages, TasterN, articleId, clumpName)
 
update a set a.joinA = bJoinA
	from 
		(select joinA
				, dbo.getJoinA(pubN, pubDate, issue, pages, TasterN, articleId, clumpName) bJoinA 
			from articleMaster
			) a
	where joinA <> bJoinA
		
update rpowinedatad..wine	set joinA = dbo.getJoinA(dbo.getPubN(publication), sourceDate, issue, pages, dbo.getTasterN(source), articleId, clumpName)
 
------------------------------------------------------------------------
-- NOTHING JOINS.  NEED TO IMPROVE GetPubN
------------------------------------------------------------------------
 
update a set a.articleMasterN = b.articleN
	select *
		from rpowinedatad..wine a
			join articleMaster b
				on a.joinA = b.joinA
			where a.articleMasterN <> b.articleN
 
end
/*
select count(*) from rpowinedatad..wine where joinA is null
 
select joinA, count(*) from rpowinedatad..wine group by joinA order by count(*)
select publication, dbo.getPubN(publication) pubN, sourceDate, issue, pages, source, dbo.getTasterN(source) tasterN, articleId, clumpName
	from rpowinedatad..wine where joinA = '0|Aug 31 2007 12:00AM|N/A||15|0|2007R\AUGUST~1\Gramenon'
 
select distinct publication from rpowinedatad..wine
ooerp
 
*/
 
 
