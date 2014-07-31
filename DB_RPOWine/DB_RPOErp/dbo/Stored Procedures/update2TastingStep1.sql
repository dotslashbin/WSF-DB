CREATE proc [dbo].[update2TastingStep1] as begin
set noCount on 
------------------------------------------------------------------------------------------------------------------------------
-- Init
------------------------------------------------------------------------------------------------------------------------------ 
exec dbo.ooLog 'update2TastingStep1 begin'
 
truncate table erpIn..tastingNew		--vTastingNew
 
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Main Update
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 
declare @ii int = 1, @iiHi int, @iiMax int , @chunk int=10000
select @iiMax = MAX(iiProducerVintage) from veWine
while @ii <= @iiMax
	begin
		set @iiHi = @ii + @chunk - 1
		exec dbo.update2TastingStep1Chunk  @ii, @iiHi
		set @ii = @iiHi+1
	end 
  
------------------------------------------------------------------------------------------
-- Adjust fields In bulk
------------------------------------------------------------------------------------------ 
exec dbo.ooLog '     update2TastingStep1 whoUpdated begin'
 
update a set updateWhN =
		case when c.whN is not null then
			c.whN
		else
			case 
				when b.whoUpdated = 'mark' then
					e.whN
				when b.whoUpdated in ('doug', 'doug2') then
					d.whn
				end
		end
	from vTastingNew a
		join veWine b
			on a._fixedId = b.fixedId     
		left join wh c
			on b.whoUpdated = c.tag     
		left join wh d
			on 	d.tag = 'dwf'
		left join wh e
			on e.tag = 'mlb'	  
 
------------------------------------------------------------------------------------------
--PubN     Never put the following two together - the or condition in the join is staggeringly inefficient 
------------------------------------------------------------------------------------------												
exec dbo.ooLog '     update2TastingStep1 pubN begin'
 update a set pubN = isNull(aliasOfWhn, whN)
	from vTastingNew a
		join veWine b
			on a._fixedId = b.fixedId
		join wh c
			on b.publication = c.fullName
	where a.pubN is null
 
 update a set pubN = isNull(aliasOfWhn, whN)
	from vTastingNew a
		join veWine b
			on a._fixedId = b.fixedId
		join wh c
			on b.publication= c.displayName
	where a.pubN is null
 
--select getName(pubN), count(*) cnt from vTastingNew group by pubN order by cnt desc
--select getName(tasterN), count(*) cnt from vTastingNew group by tasterN order by cnt desc
 
 
------------------------------------------------------------------------------------------
--TasterN     Never put the following two together - the or condition in the join is staggeringly inefficient 
------------------------------------------------------------------------------------------												
exec dbo.ooLog '     update2TastingStep1 tasterN begin'
update a set tasterN = isNull(aliasOfWhn, whN)
	from vTastingNew a
		join veWine b
			on a._fixedId = b.fixedId
		join wh c
			on b.[source] = c.fullName
	where tasterN is null
 
update a set tasterN = isNull(aliasOfWhn, whN)
	from vTastingNew a
		join veWine b
			on a._fixedId = b.fixedId
		join wh c
			on b.[source]= c.displayName
	where tasterN is null
 
 
 
------------------------------------------------------------------------------------------
-- BottleSize
------------------------------------------------------------------------------------------
exec dbo.ooLog '     update2TastingStep1 bottleSize begin'
update a
	set a.bottleSizeN= 
		case
			when c.bottleSizeN is null then
				d.bottleSizeN	--Standard Bottle Size from BottleSize table
			else
				c.bottleSizeN
		end
	from vTastingNew a
		join veWine b
			on a._fixedId = b.fixedId
		left join bottleSizeAlias c
			on c.alias = dbo.superTrim(b.bottleSize)
		join bottleSize d
			on d.litres = 0.75
 
------------------------------------------------------------------------------------------------------------------------------
-- proTasting flag
------------------------------------------------------------------------------------------------------------------------------
exec dbo.ooLog '     update2TastingStep1 proTasting begin'
update a 
	set a.isProTasting = isNull(b.isProfessionalTaster, 0)
	from vTastingNew a
		left join wh b
			on a.pubN = b.whN
			
	
 
------------------------------------------------------------------------------------------------------------------------------
-- Update WineNameN
------------------------------------------------------------------------------------------------------------------------------
exec dbo.ooLog '     update2TastingStep1 wineNameN begin'
update a set a.wineNameN=b.wineNameN
	from vTastingNew a
		join wine b
			on a.wineN=b.wineN
	where a.wineNameN <> b.wineNameN or (a.wineNameN is null and b.wineNameN is not null) or (a.wineNameN is not null and b.wineNameN is null)
 
exec dbo.ooLog 'update2TastingStep1 end'
 
end
