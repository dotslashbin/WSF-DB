create proc [dbo].[exampleMerge]
as begin

merge bottleSizeAlias as a
	using erp..bottleSize b
		on a.alias=b.name
when matched and a.bottleSizeN <> b.bottleSizeN or b.bottleSizeN is null then
	update set bottleSizeN=b.bottleSizeN
when not matched by target then
	insert(alias, bottleSizeN)
		values(b.name, b.bottleSizeN);



end
