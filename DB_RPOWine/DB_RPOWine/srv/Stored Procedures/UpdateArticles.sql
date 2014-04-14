-- =============================================
-- Author:		Alex B.
-- Create date: 4/13/14
-- Description:	Adoptation of the UpdateArticles stored procedure,
--				originally developed by Julian
--				and located in the RPOWineData DB.
-- NOTE: USES & UPDATES RPOWine database objects.
-- =============================================
CREATE PROCEDURE [srv].[UpdateArticles] 

--
-- Part of the Julian's price processing
--
-- NOTE: Newly created articles will have larger articleIdNKey = -(ID + 100000000 + @base/10)
--

AS
set nocount on;

declare @max int, @base int
set @base = 999000000;

with a as (
	select row_number() over (partition by oldArticleIdNKey order by oldArticleIdN) ii, * 
	from Article 
	where isnull(oldArticleIdNKey, 0) >= @base or isnull(oldArticleIdNKey, 0) < 0
)
update a set 
	oldArticleIdNKey = null 
where ii > 1

update Article set 
	oldArticleIdNKey = case
		when oldArticleIdN is NOT NULL then -(oldArticleIdN + @base/10)
		else -(ID + 100000000 + @base/10)
	end
where oldArticleIdNKey is null;

update TasteNote set oldArticleIdNKey = null where oldArticleIdNKey > @base

-- Just latest article - WineAdvocate and Robert Parker must always have a priority.
declare @d date = getdate()
; with r as (
	select ArticleID = a.ID, atn.TasteNoteID, a.oldArticleId, a.oldArticleIdN, a.oldArticleIdNKey, 
		--p.PublisherID, a.Author, a.Date, 
		R = p.PublisherID * 10000 
			+ case
				when lower(isnull(a.Author, u.FullName)) like '%robert%parker%' then 0
				else 1
			end * 1000 
			+ datediff(day, a.Date, @d)
	from Article_TasteNote atn (nolock)
		join Article a (nolock) on atn.ArticleID = a.ID
		join Publication p (nolock) on a.PublicationID = p.ID
		left join Users u (nolock) on a.AuthorId = u.UserId
), s as (
	select TasteNoteID, R = min(R)
	from r
	group by TasteNoteID
)
update TasteNote set 
	oldArticleId = r.oldArticleId,
	oldArticleIdNKey = r.oldArticleIdNKey,
	ArticleID = r.ArticleID
from r
	join s on r.TasteNoteID = s.TasteNoteID and r.R = s.R
	join TasteNote tn on r.TasteNoteID = tn.ID
; 
--------------------------------------------------------------------------
-- The rest of the "old" logic - article order, article overlap, overlap rank
-- is NOT IN USE!
--------------------------------------------------------------------------
		
RETURN 1