-- database update		[=]
CREATE procedure updateErpWineFromAlt as begin

-- HAVE TO ADD ENCODEDKEYWORDS

------------------------------------------------------------------------
--(205). Set Up Wine Table
------------------------------------------------------------------------
--select count(*) from wine
exec snapRowVersion erp;
delete from wine where wineN < 0

set identity_insert wine on;
insert into wine(wineN,activeVinn,wineNameN,vintage,encodedKeywords)
	select wineN,vinN,wineNameN,vintage, encodedKeywords
		from wineAlt z
		where isActiveWineNameForWineN = 1 and isInactive = 0
			and not exists
				(select * from wine where z.wineN = wineN)
set identity_insert wine off;

update z
	set	 z.activeVinn = y.vinn
			,z.wineNameN = y.wineNameN
			,z.vintage = y.vintage
			,z.encodedKeywords = y.encodedKeywords
	from wine z
		join wineAlt y
			on z.wineN = y.wineN 
				and y.isActiveWineNameForWineN = 1 
				and y.isInactive = 0
	where
			(z.activeVinn is null and y.vinn is not null) or (z.activeVinn is not null and y.vinn is null) or (z.activeVinn <> y.vinn)
			or (z.wineNameN is null and y.wineNameN is not null) or (z.wineNameN is not null and y.wineNameN is null) or (z.wineNameN <> y.wineNameN)
			or (z.vintage is null and y.vintage is not null) or (z.vintage is not null and y.vintage is null) or (z.vintage <> y.vintage)
			or (z.encodedKeywords is null and y.encodedKeywords is not null) or (z.encodedKeywords is not null and y.encodedKeywords is null) or (z.encodedKeywords <> y.encodedKeywords)
	
delete 
	from wine
	where not exists
		(select * from wineAlt a
			where a.wineN = wine.wineN
				and isActiveWineNameForWineN  = 1
				and isInactive = 0
			)

exec snapRowVersion erp;
end
