--test whEx [=]
CREATE proc setFakeWhEx(@whN int, @x1 float, @y1 float) as begin
 
--declare @x1 float, @y1 float,  @x2 float, @y2 float,  @x3 float, @y3 float,  @x4 float, @y4 float,  @x5 float, @y5 float
 
 
if 0 = (select COUNT(*)  from whEx where whN = @whN) begin
	set identity_insert whEx on
	insert into whEx(whN) select @whN
	set identity_insert whEx off
	end

 
update whEx
set 
 
recentSpanMonths = 6,
needToDrinkSpanMonths = 12,
whoTrustsMeCnt = 3, 
forSaleWineCnt = 5, 
forSaleBuyerCnt = 2, 
wantToBuyWineCnt = 20, 
wantToBuySellerCnt = 2, 
watchListCnt = 5, 
needToDrinkWineCnt = 13, 
needToDrinkBottleCnt = 78, 
 
trustedTasterTastingNoteCnt = 12782 * @x1,
trustedTasterTastingNoteRecentCnt = 1131  * @x1, 
trustedTasterTastingNoteRatedHelpfulCnt = 4738 * @x1, 
trustedTasterTastingNoteRatedHelpfulRecentCnt =  522 * @x1, 
trustedTasterTastingNoteViewCnt = 220332 * @x1, 
trustedTasterTastingNoteViewRecentCnt = 26122 * @x1, 
trustedTasterArticleCnt = 16 * @y1, 
trustedTasterArticleRecentCnt = 3 * @y1, 
trustedTasterArticleRatedHelpfulCnt = 5 * @y1, 
trustedTasterArticleRatedHelpfulRecentCnt = 1 * @y1, 
trustedTasterArticleViewCnt = 7888 * @y1, 
trustedTasterArticleViewRecentCnt = 652 * @y1, 
 
myPublicationTastingNoteCnt = 12782 * @x1, 
myPublicationTastingNoteRecentCnt = 1131 * @x1, 
myPublicationTastingNoteRatedHelpfulCnt = 4738 * @x1, 
myPublicationTastingNoteRatedHelpfulRecentCnt =  522 * @x1, 
myPublicationTastingNoteViewCnt = 220332 * @x1, 
myPublicationTastingNoteViewRecentCnt = 26122 * @x1, 
myPublicationArticleCnt = 16* @y1, 
myPublicationArticleRecentCnt = 3* @y1, 
myPublicationArticleRatedHelpfulCnt = 5* @y1, 
myPublicationArticleRatedHelpfulRecentCnt = 1* @y1, 
myPublicationArticleViewCnt = 7888* @y1, 
myPublicationArticleViewRecentCnt = 652* @y1, 
 
 
myGroupsTastingNoteCnt = 12782 * @x1, 
myGroupsTastingNoteRecentCnt = 1131 * @x1, 
myGroupsTastingNoteRatedHelpfulCnt = 4738 * @x1, 
myGroupsTastingNoteRatedHelpfulRecentCnt =  522 * @x1, 
myGroupsTastingNoteViewCnt = 220332 * @x1, 
myGroupsTastingNoteViewRecentCnt = 26122 * @x1, 
myGroupsArticleCnt = 16* @y1, 
myGroupsArticleRecentCnt = 3* @y1, 
myGroupsArticleRatedHelpfulCnt = 5* @y1, 
myGroupsArticleRatedHelpfulRecentCnt = 1* @y1, 
myGroupsArticleViewCnt = 7888* @y1, 
myGroupsArticleViewRecentCnt = 652* @y1, 
 
 
MyOwnTastingNoteCnt = 12782 * @x1, 
MyOwnTastingNoteRecentCnt = 1131 * @x1, 
MyOwnTastingNoteRatedHelpfulCnt = 4738 * @x1, 
MyOwnTastingNoteRatedHelpfulRecentCnt =  522 * @x1, 
MyOwnTastingNoteViewCnt = 220332 * @x1, 
MyOwnTastingNoteViewRecentCnt = 26122 * @x1, 
MyOwnArticleCnt = 16* @y1, 
MyOwnArticleRecentCnt = 3* @y1, 
MyOwnArticleRatedHelpfulCnt = 5* @y1, 
MyOwnArticleRatedHelpfulRecentCnt = 1* @y1, 
MyOwnArticleViewCnt = 7888* @y1, 
MyOwnArticleViewRecentCnt = 652* @y1
 
where whN = @whN
end
 
/*
 
select * from wh where fullName like '%savchen%'
 
setFakeWhEx 19, .3, .2
setFakeWhEx 20, .2, .6
setFakeWhEx 22, .2, .7
 
set identity_insert whex on
insert into whex(whN) select 22
 
*/
