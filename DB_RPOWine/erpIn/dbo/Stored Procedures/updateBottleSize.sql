CREATE proc updateBottleSize
/*
use erpIn
create view vBottleSize as select * from erp11..bottleSize
create view vBottleSizeJulian as select * from erpIn..bottleSizes
*/
as begin
set nocount on

/*
truncate table bottleSizeAlias
insert into bottleSizeAlias([alias],bottleSizeN,litres)
	select [alias],bottleSizeN,litres from erp..bottleSizeAlias

truncate table bottleSizeJulian
insert into bottleSizeJulian(BottleSize,BottlesperCase,LitersperBottle)
	select BottleSize,BottlesperCase,LitersperBottle from erp..bottleSizes

select * from bottleSizeAlias

*/
truncate table bottleSize
set identity_insert bottleSize on
insert into bottleSize(bottleSizeN,name,litres,createDate,updateDate,shortName,nameInSummary)
	select bottleSizeN,name,litres,createDate,updateDate,shortName,nameInSummary from vBottleSize
set identity_insert bottleSize off

merge bottleSizeAlias a
	using vBottleSize b
		on a.alias=b.name
when matched and a.bottleSizeN is null or a.bottleSizeN <> b.bottleSizeN or a.litres is null or a.litres <> b.litres then
	update set bottleSizeN=b.bottleSizeN, litres = b.litres
when not matched by target then
	insert(alias, bottleSizeN, litres)
		values(b.name, b.bottleSizeN, litres);
		
merge bottleSizeAlias a
	using (select * from vBottleSize where litres is not null) b
		on a.bottleSizeN=b.bottleSizeN
when matched and a.litres is null or a.litres <> b.litres then
	update set litres = b.litres;
		
merge bottleSizeAlias a
	using (select bottleSize from erpWine where bottleSize not like '%[^ ]%'  group by bottleSize) b
		on a.alias = b.bottleSize
when not matched by target then
	insert(alias) values(b.bottleSize);
 
merge bottleSizeAlias a
	using (select bottleSize, litersPerBottle from erp..bottleSizes where bottleSize  like '%[^ ]%') b
		on a.alias = b.bottleSize
when matched and (a.litres is null and b.litersPerBottle is not null) or a.litres <> b.litersPerBottle then
	update set litres = b.litersPerBottle
when not matched by target then
	insert(alias, litres) values(bottleSize, litersPerBottle);
 
 
 
end
 
