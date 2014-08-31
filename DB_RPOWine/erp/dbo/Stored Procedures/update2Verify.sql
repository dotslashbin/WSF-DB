
CREATE proc [dbo].[update2Verify] as begin
set noCount on;
-----------------------------------------------------------------------------------
-- Check the prices
----------------------------------------------------------------------------------
with 
a as	(
		select '=>' _,Producer,labelname,a.vintage,vinn,winen,MostRecentPrice Lo,MostRecentPriceHi Hi
			from vjwine a
				join mapjtoe b on a.winen=b.jwinen
			--where mostrecentprice>0 and vinn>0
		union
		select '' _,Producer,labelname,a.vintage,a.activevinn vinn,winen,MostRecentPriceLoStd Lo,MostRecentPriceHiStd Hi
			from wine a 
				join mapjtoe b on a.winen=b.ewinen
				join winename c on a.winenamen=c.winenamen
		)
select * from a 
	where producer like '%etrus%' and lo is not null
	order by producer,labelname,vintage,_ desc
 
-----------------------------------------------------------------------------------
-- Check the tasting
----------------------------------------------------------------------------------
 
;with
j as	(
		select '=>' _,fixedid,Producer,labelname,a.vintage,vinn,jwinen,ewinen winen
			from vjwine a
				join mapjtoe b on a.winen=b.jwinen
			--where producer like '%qua%'
			where labelname like '%qu%'
		)
,e as	(
		select '' _,_fixedid fixedid,c.Producer,c.labelname,a.vintage,a.activeVinn vinn,0 jwinen,a.winen
			from wine a 
				join tasting b on a.winen=b.winen
				join winename c on c.winenamen=a.winenamen
				join j on j.fixedid=b._fixedid
		)
select * from e
	union
	select * from j
	where fixedid>0
	order by fixedid,_ desc
 
end
 







