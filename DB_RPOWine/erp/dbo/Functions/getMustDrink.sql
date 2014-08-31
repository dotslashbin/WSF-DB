CREATE function getMustDrink(@whN int)
returns @T table(
	whN int
	, wineN int
	, vintage varchar(4)
	, producerShow nvarchar(100)
	, labelName nvarchar(150)
	, matchName nvarchar(500)
	, bottleCount smallint
	, proUnifiedN smallint
	, proTasteDate smalldatetime
	, userUnifiedN smallint
	, userTasteDate smalldatetime
	, trustedUnifiedN smallint
	, trustedTasteDate smalldatetime
	)
as begin 
	with
	e as		(	select z.whN, y.wineN, bottleCount		from wh z
					join whToWine y on y.whN=z.whN
					where z.whN=@whN     )
	,a as	(	select e.whN,e.bottleCount, x.*			from e
					join tasting x on x.wineN=e.wineN     )
	,b1 as	(	select row_number() over(partition by a.whN,wineN order by tasteDate desc, updateDate desc)ii, a.* from a
					join whToTrustedTaster z on z.tasterN=a.tasterN and z.whN=a.whN
					where a.isPrivate=0     )
	,b2 as	(	select row_number() over(partition by a.whN,wineN order by tasteDate desc, updateDate desc)ii, a.* from a where isProTasting=1 and isPrivate=0     )
	,b3 as	(	select row_number() over(partition by a.whN,wineN order by tasteDate desc, updateDate desc)ii, a.* from a where tasterN=whN     )
	,c1 as	(	select dbo.getUnifiedDrinkWhen(drinkDate, drinkDateHi, maturityN, decantedN, drinkWhenN) unifiedN, b1.* from b1 where ii=1     )
	,c2 as	(	select dbo.getUnifiedDrinkWhen(drinkDate, drinkDateHi, maturityN, decantedN, drinkWhenN) unifiedN, b2.* from b2 where ii=1     )
	,c3 as	(	select dbo.getUnifiedDrinkWhen(drinkDate, drinkDateHi, maturityN, decantedN, drinkWhenN) unifiedN, b3.* from b3 where ii=1     )
	,d as	(	select whN, wineN, unifiedN from c1 where unifiedN in (4,5,104,105) union 
				select whN, wineN, unifiedN from c2 where unifiedN in (4,5,104,105) union 
				select whN, wineN, unifiedN from c3  where unifiedN in (4,5,104,105)    )
insert into @T(whN, wineN, vintage, producerShow, labelName, matchName, bottleCount, proUnifiedN, proTasteDate, userUnifiedN, userTasteDate, trustedUnifiedN, trustedTasteDate)
	select d.whN, d.wineN, vintage, producerShow, labelName, matchName, e.bottleCount
				, c2.unifiedN proUnifiedN, c2.tasteDate proTasteDate
				, c3.unifiedN userUnifiedN, c3.tasteDate userTasteDate
				, c1.unifiedN trustedUnifiedN, c1.tasteDate trustedTasteDate
		from d
			left join c1 on d.whN=c1.whN and d.wineN=c1.wineN
			left join c2 on d.whN=c2.whN and d.wineN=c2.wineN
			left join c3 on d.whN=c3.whN and d.wineN=c3.wineN
			join e on e.whN=d.whN and e.wineN=d.wineN
				join wine f on f.wineN=e.wineN
					join wineName g on g.wineNameN=f.wineNameN
 
 
 
 
 
 
 
 
 
 
 
 
 
 
return 
end
