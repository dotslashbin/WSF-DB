-- database getJoinA joinA utility [=]
CREATE FUNCTION [dbo].[getJoinA]
(
@pubN int,@pubDate smalldatetime, @issue nvarchar(50), @pages varchar(20), @tasterN int, @articleId int, @clumpName varchar(200)
)
RETURNS nvarchar(max)
AS
BEGIN
	Declare @R nvarchar(max)
	declare @n varchar(2000); set @n = ''
	declare @s varchar(2000); set @s = '|'
	set @R = 
		 (
			convert(varchar, isNull(@pubN, @n))
			+@s+convert(varchar, isNull(@pubDate, @n))
			+@s+convert(varchar, isNull(@issue, @n))
			+@s+convert(varchar, isNull(@pages, @n))
			+@s+convert(varchar, isNull(@tasterN, @n))
			+@s+convert(varchar, isNull(@articleId, @n))
			+@s+convert(varchar, isNull(@clumpName, @n))
 			)
 
 
	RETURN @R
 
END
/*
ooi articleMaster, ''

update rpowinedatad..wine
	set joinA = dbo.getJoinA(dbo.getPubN(publication), sourceDate, issue, pages, dbo.getTasterN(source), articleId, clumpName)

select dbo.getPubN(publication) pubN,sourceDate pubDate,issue,title,pages,dbo.getTasterN(source) tasterN,articleId,articleIdnKey _x_articleIdnKey

ooi clumpname

with
 a as (select joinA, articleIdnKey from rpowinedatad..wine group by joinA, articleIdnKey)
,b as (select joinA, count(*) cnt from a group by joinA having count(*) > 1)
select * from b

select joinA, articleIdnKey from rpowinedatad..wine where joinA = '0|Aug 31 2007 12:00AM|N/A||15|0|2007R\AUGUST~1\Alary'

*/
 
