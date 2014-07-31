-------------------------------------------------------------------------------------------------------------------------
-- updateNameYearActiveBits
-------------------------------------------------------------------------------------------------------------------------
CREATE proc [zupdateNameYearActiveBits]
as begin
	set noCount on
 
	update nameYear
		set 
			 isVinnWid = 0
			,isWidVinn = 0
			,isNameVinn = 0
			,isNameWid = 0;
 
	with
	 a as (select vinn, wineNameN, isNameVinn, vintage, rank() over (partition by vinn order by vintage desc, wineNameN) iRank from nameYear where vinn is not null and wineNameN is not null)
	,b as (select distinct(wineNameN) from a where iRank = 1)
	update c set isNameVinn = 1
		from nameYear c
			join b on c.wineNameN = b.wineNameN;
  
	with
	 a as (select vinn, wid, isVinnWid, vintage, rank() over (partition by vinn order by vintage desc, wid) iRank from nameYear where vinn is not null and wid is not null)
	,b as (select distinct(wid) from a where iRank = 1)
	update c set isVinnWid = 1
		from nameYear c
			join b on c.wid = b.wid;
			
	with
	 a as (select wid, wineNameN, isNameWid, vintage, rank() over (partition by wid order by vintage desc, wineNameN) iRank from nameYear where wid is not null and wineNameN is not null)
	,b as (select distinct(wineNameN) from a where iRank = 1)
	update c set isNameWid = 1
		from nameYear c
			join b on c.wineNameN = b.wineNameN;
  
	with
	 a as (select wid, vinn, iswidvinn, vintage, rank() over (partition by wid order by vintage desc, vinn) iRank from nameYear where wid is not null and vinn is not null)
	,b as (select distinct(vinn) from a where iRank = 1)
	update c set isWidVinn = 1
		from nameYear c
			join b on c.vinn = b.vinn;
 
	 with
	 a as (select wineNameN, vinn, isNameVinn, vintage, rank() over (partition by wineNameN order by vintage desc, wid) iRank from nameYear where wineNameN is not null and vinn is not null)
	,b as (select distinct(vinn) from a where iRank = 1)
	update c set isNameVinn = 1
		from nameYear c
			join b on c.vinn = b.vinn;
	
	 with
	 a as (select wineNameN, wid, isNamewid, vintage, rank() over (partition by wineNameN order by vintage desc, wid) iRank from nameYear where wineNameN is not null and wid is not null)
	,b as (select distinct(wid) from a where iRank = 1)
	update c set isNamewid = 1
		from nameYear c
			join b on c.wid = b.wid;
	
end
 
/*
updateNameYearActiveBits
 
select * from vname order by iName, iBase
select * from vname order by iName
select * from vname  where wid is not null and nv <> wv order by iName
select * from vname where vinn = 44920 or wid = 'sp1998100'
 
*/
 
 
 
 
