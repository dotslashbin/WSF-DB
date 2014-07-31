CREATE proc steps as begin
 --aa>     set vinn2 to the eRP vinn for the most recent vintage for this wid
	--aaa     set producer2 and producerShow2 to erp producer when there is a vinn
		--aab     translate other wines with same wid producer
		--aac     fill in the remaining ones from vAlertOK
--ab>     Create new non-erp Vinns for wid mapping
	--aba.		make sure we have all the vinns already in use from erpWine and vAlert
	--abb.     create vinn's from 1 milllion down.  reserve above 1 million for created wineN for existing vinn
--b>     Update nameYearRaw 
--ba>     Add in all current eRP wines
--baa>     Analyze Errors
--bab>     Update Vinn2 from allocateVinn
--bb>.     Add succesive goups of wine to nameYear
--bba>    add in erpFields for forSale items with wineN	
--bbb>     add in erp wine where wineN can be uniquely deduced from erpWine through wid=>vinn, vintage
--bbc>     add in erpFields where there is wid=>vinn but no wineN can be deduced.  use vinn, create a wineN     ACTIVE
--bbda>.    add in vAlertOK for forSale items with no vinn.  but there is a valid erp producer.   use newly created vinn then create a wineN
--bbdb>.    add in vAlertOK for forSale items with no vinn.  but there is a no valid erp producer.   use newly created vinn then create a wineN
--bbe>     add in erpFields for vAlertOK not already in nameyear
--bbf>     ?? add in wine alert db not currently for sale

declare @j int
end
/*	

select prod, producer2, * from vAlertOK where prod <> producer2

select a.wid, a.vinn2, prod, producer2, a.* 
	from vAlertOK a
		join (select distinct wid from fforSale4) b
			on a.wid = b.wid
	where prod <> producer2
	order by a.vinn2
	
	br1688100	415
	it1316104	14465	
	rh1287100	18808
	sp1193100	31658
	rh1505100	33147

select * from vForSale where wid = 'br1688100'
select * from vForSale where wid = 'br1688100' and wineN is null order by vintage
select * from vForSale4 where wid = 'br1688100' and wineN is null order by vintage
select phase, * from nameYearRaw where wid =  'br1688100' order by vintage
	bba>	154455	74582	52883	br1688100
	bba>	146023	21964	52883	br1688100
	bba>	146072	21973	52883	br1688100
	bba>	148041	34719	52883	br1688100
	bba>	149132	41888	52883	br1688100
	bba>	152316	63757	52883	br1688100
	bba>	171787	132500	52883	br1688100







*/