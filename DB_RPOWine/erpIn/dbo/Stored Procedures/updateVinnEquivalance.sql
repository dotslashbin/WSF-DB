CREATE proc updateVinnEquivalance as
begin
	declare @date smallDateTime = getDate()
	
	
	-------------------------------------------------------
	-- map through erpWine
	-------------------------------------------------------

	merge mapWineVinn as aa
		using 
			(
			select a.wineN, a.vintage, a.vinn
			from erpWine a
			group by wineN, vintage, vinn
			) as bb
		on aa.wineN = bb.wineN and aa.vintage = bb.vintage and aa.vinn = bb.vinn
	when matched then
		update set aa.dateHi = @date, isOld = 0
	when not matched by target then
		insert (wineN, vintage, vinn, dateHi, isOld)
			values(bb.wineN, bb.vintage, bb.vinn, @date, 0)
	when not matched by source then
		update set aa.isOld = 1;



	-------------------------------------------------------
	-- map through julian exact forSale WineN 
	-------------------------------------------------------	
	merge mapWidWine as aa
		using 
			(
			select [WineAlert ID] wid, b.vintage, b.wineN
				from waForSale a
					join erpWine b
						on a.wineN = b.wineN
				group by [WineAlert ID], b.vintage, b.wineN
			) as bb
		on aa.wid = bb.wid and aa.vintage = bb.vintage and aa.wineN = bb.wineN
	when matched then
		update set aa.dateHi = @date, isOld = 0
	when not matched by target then
		insert (wid, vintage, wineN, dateHi, isOld)
			values(bb.wid, bb.vintage, bb.wineN, @date, 0)
	when not matched by source then
		update set aa.isOld = 1;







	-------------------------------------------------------
	-- add mappings from wid
	-------------------------------------------------------
/*
	with
	a as
		(
			select [WineAlert ID]wid, null wineN, vinn
				from waWineAlertDatabase
				where isNumeric(vinn) = 1
		union
			select wid, wineN, vinn
				from mapWidWine 
				where isOld = 0			 
		) 
	select * from a
*/	
	
	merge mapWidVinn as aa
		using 
			(select [WineAlert ID]wid, vinn
				from waWineAlertDatabase
				where isNumeric(vinn) = 1
				group by [WineAlert ID], vinn
			) as bb
		on aa.wid = bb.wid and aa.vinN = bb.vinN
	when matched then
		update set aa.dateHi = @date, isOld = 0
	when not matched by target then
		insert (wid, vinN, dateHi, isOld)
			values(bb.wid, bb.vinN, @date, 0)
	when not matched by source then
		update set aa.isOld = 1;








end

/*

delete from mapWidVinn
delete from mapWidWine
delete from mapWineVinn

updateVinnEquivalance

select count(*) from mapWineVinn
select * from mapWineVinn

select count(*) from mapWidWine
select * from mapWidWine

*/