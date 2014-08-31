CREATE proc updateTastingNewFromEWS
as begin
							     
truncate table tastingNew;
 
------------------------------------------------------------------------------------------
-- update wineN from URL
------------------------------------------------------------------------------------------
update vEws set wineN = dbo.extractWineNFromURl(url)
 
 
------------------------------------------------------------------------------------------
-- Insert into tastingNew
------------------------------------------------------------------------------------------
declare @ewsPubN int, @today date = getDate()
	select @ewsPubN = whN from erp..wh where tag = 'pubEws'
	
	insert into tastingNew     (
			  dataSourceN
			, dataIdN
			, dataIdNDeleted 
			, rating
			, notes
			, wineN
			,  pubN
			,  pubDate
			,  tasterN
			, tasteDate
			, _clumpName
			, updateDate
			, isProTasting
			, canBeActiveTasting
		     )	
	select
			  @ewsPubN
			, idN
			, 0 
			, rating
			, notes
			, wineN
			, @ewsPubN	--pubN
			, sourceDate	--pubDate
			, @ewsPubN	--tasterN
			, sourceDate	--tasteDate
			, 'cherylEws1005ay15'	--_clumpName??	  
			, @today
			, 0	--isProTasting
			, 0	--canBeActiveTasting=0
 
		from vEws
		
------------------------------------------------------------------------------------------------------------------------------
-- proTasting flag
------------------------------------------------------------------------------------------------------------------------------
update a 
	set a.isProTasting = isNull(b.isProfessionalTaster, 0)
	from tastingNew a
		left join vWh b
			on a.pubN = b.whN




	------------------------------------------------------------------------------------------
	-- update in bulk
	------------------------------------------------------------------------------------------
/*
	od tastingNew, pubN
	select * from erp..wh where fullName like '%exec%'
	od tasting, 'bottleSizeN publicatiion'
	
	od erpWine, 'bottleSize'
	oon wine,''
 
	update in bulk
	, xxx	--maturityN
 
O	update vEws set wineN = dbo.extractWineNFromURl(url)
*/
	
	
end
 
 
 
