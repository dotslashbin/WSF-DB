CREATE proc updateBottleSizeAlias
as begin
set nocount on
merge erp..bottleSizeAlias a
	using erp..bottleSize b
		on a.alias=b.name
when matched and a.bottleSizeN is null or a.bottleSizeN <> b.bottleSizeN or a.litres is null or a.litres <> b.litres then
	update set bottleSizeN=b.bottleSizeN, litres = b.litres
when not matched by target then
	insert(alias, bottleSizeN, litres)
		values(b.name, b.bottleSizeN, litres);
		
merge erp..bottleSizeAlias a
	using (select * from erp..bottleSize where litres is not null) b
		on a.bottleSizeN=b.bottleSizeN
when matched and a.litres is null or a.litres <> b.litres then
	update set litres = b.litres;
		
merge erp..bottleSizeAlias a
	using (select bottleSize from erpWine where bottleSize not like '%[^ ]%'  group by bottleSize) b
		on a.alias = b.bottleSize
when not matched by target then
	insert(alias) values(b.bottleSize);

merge erp..bottleSizeAlias a
	using (select bottleSize, litersPerBottle from erp..bottleSizes where bottleSize  like '%[^ ]%') b
		on a.alias = b.bottleSize
when matched and (a.litres is null and b.litersPerBottle is not null) or a.litres <> b.litersPerBottle then
	update set litres = b.litersPerBottle
when not matched by target then
	insert(alias, litres) values(bottleSize, litersPerBottle);



end
