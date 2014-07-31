------------------------------------------------------------------------------------------------------------------------------
-- tastingSQL
------------------------------------------------------------------------------------------------------------------------------
CREATE function tastingSQL(@whN int =null, @pubGN int=18223, @doGetAllTastings bit = 0, @mustHaveReview bit = 0, @mustHaveTrusted bit = 0)
returns varChar(max)
as begin
------------------------------------------------------------------------------------------------------------------------------
-- Go out with wTasting which in turn uses wQualified
------------------------------------------------------------------------------------------------------------------------------
/*
declare @qq varchar(max)=dbo.tastingSQL(20,18223,0,1,0)
set @qq = 'with
' + @qq + '
select a.* 	from td a	join wine b		on a.wineN=b.wineN	where contains(encodedKeywords, ''   "sine*" and  "qua*"   '')	order by a.wineN'
 
print (@qq)
exec (@qq)
*/
 
 
--declare @doGetAllTastings bit = 0, @mustHaveReview bit = 0, @mustHaveTrusted bit = 0
--declare @doGetAllTastings bit = 0, @mustHaveReview bit = 0, @mustHaveTrusted bit = 1
--declare @doGetAllTastings bit = 0, @mustHaveReview bit = 1, @mustHaveTrusted bit = 0
--declare @doGetAllTastings bit = 0, @mustHaveReview bit = 1, @mustHaveTrusted bit = 1
--declare @doGetAllTastings bit = 1, @mustHaveReview bit = 0, @mustHaveTrusted bit = 1
--declare @doGetAllTastings bit = 1, @mustHaveReview bit = 1, @mustHaveTrusted bit = 0
 
--declare @doGetAllTastings bit = 1, @mustHaveReview bit = 1, @mustHaveTrusted bit = 1
--declare @whN int =20, @pubGN int=18223
declare @q varchar(max)=''
 
if @mustHaveReview=1
	begin
		if  @mustHaveTrusted=1
			begin
				set @q='
ta as (
	select a.tastingN
		from     (
			select tastingN
				from tasting ata
				join pubGToPub bta
					on ata.pubN = bta.pubN and bta.pubGN = '+convert(varchar, @pubGN)+'     ) a
		join     (
			select tastingN
				from tasting cta
				join whToTrustedTaster dta
					on cta.tasterN = dta.tasterN and dta.whN = '+convert(varchar, @whN)+'     )b
			on a.tastingN = b.tastingN     )
,@tastings@ as (
	select itc.*
		from tasting itc
			join ta
				on itc.tastingN = ta.tastingN     )'
			end
		else
			begin
				set @q='
@tastings@ as (
	select ata.*
		from tasting ata
			join pubGToPub bta
				on ata.pubN = bta.pubN and bta.pubGN = '+convert(varchar, @pubGN)+'     )'
			end
	end
else
	begin
		if @mustHaveTrusted=1
			begin
				set @q='
@tastings@ as (
	select cta.*
		from tasting cta
			join whToTrustedTaster dta
				on cta.tasterN = dta.tasterN and dta.whN = '+convert(varchar, @whN)+'     )'		
			end
	end
 
if @doGetAllTastings=0
	begin
		set @q+='
' +case when len(@q)>0 then ',' else '' end+'td as (
	select *
		from @tastings@ jtd
		where tastingN = 
				(select top 1 tastingN
					from @tastings@ with (index([ix_tasting_activeWine]))
					where wineN=jtd.wineN
					order by wineN asc,hasRating2 desc,isWA desc,isErpPro desc,ParkerZralyLevel desc,tasteDate desc,tastingN asc)     )'
	end
	
if @mustHaveReview=1 or @mustHaveTrusted=1
	begin
		if @doGetAllTastings=0
			set @q = replace(@q, '@tastings@', 'tc')
		else
			set @q = replace(@q, '@tastings@', 'td')
	end
else
	begin
		set @q = replace(@q, '@tastings@', 'tasting')
	end
 
return @q
/*
set @q = 'with
' + @q + '
select a.* 	from td a	join wine b		on a.wineN=b.wineN	where contains(encodedKeywords, ''   "sine*" and  "qua*"   '')	order by a.wineN'
	
 
print (@q)
exec (@q)
*/
end
 
 
 
 
 



