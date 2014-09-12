-- =============================================
-- Author:		Alex B.
-- Create date: 9/7/2014
-- Description:	Gets list of articles with basic statistics
-- =============================================
CREATE PROCEDURE Article_Search
	@ArticleIdNKey int = NULL, @ArticleID int = NULL, 
	@IssueID int = NULL, @IssueTitle varchar(255) = NULL

--
-- exec Article_Search @IssueTitle='214'
--
--

AS
set nocount on

-- cannot do it because no articleIdNKey neither IssueTitle are unique
--if @ArticleID is null and @ArticleIdNKey is not null
--	select @ArticleID = max(ID) from Article (nolock) where oldArticleIdNKey = @ArticleIdNKey
--if @IssueID is null and @IssueTitle is not null
--	select @IssueID = max(ID) from Issue (nolock) where Title = @IssueTitle

; with stat as (
	select 
		ArticleID = atn.ArticleID,
		cntProducer = count(distinct wv.ProducerID),
		cntWine = count(distinct wn.ID)
	from Article_TasteNote atn (nolock)
		join TasteNote tn (nolock) on atn.TasteNoteID = tn.ID
		join Wine_N wn (nolock) on tn.Wine_N_ID = wn.ID
		join Wine_VinN wv (nolock) on wn.Wine_VinN_ID = wv.ID
		left join Issue_Article ia (nolock) on atn.ArticleID = ia.ArticleID
	where 
			(@ArticleID is null or atn.ArticleID = @ArticleID)
		and (@IssueID is null or ia.IssueID = @IssueID)
	group by atn.ArticleID
)
select 
    PublicationID = a.PublicationID,
    PublicationName = p.Name,
	IssueID = i.ID,
	IssueTitle = i.Title,
	ArticleID = a.ID,
	ArticleIdNKey = isnull(a.oldArticleIdNKey, 0),
	ArticleTitle = a.Title,
	--ArticleShortTitle = a.ShortTitle,
	ArticleSource = isnull(a.Source, ''),
	ArticleAuthorID = a.AuthorId,
	ArticleAuthor = a.Author,
	ArticleFileName = a.FileName,
	cntProducer = stat.cntProducer,
	cntWine = stat.cntWine
from Article a (nolock)
	join stat on a.ID = stat.ArticleID
	join Issue_Article ia (nolock) on a.ID = ia.ArticleID
	join Issue i (nolock) on ia.IssueID = i.ID
	join Publication p (nolock) on a.PublicationID = p.ID
where 
		(@ArticleID is null or a.ID = @ArticleID)
	and (@ArticleIdNKey is null or a.oldArticleIdNKey = @ArticleIdNKey)
	and (@IssueID is null or ia.IssueID = @IssueID)
	and (@IssueTitle is null or i.Title = @IssueTitle)

RETURN 1