--select * from savedVersions2 where whn=20 order by createDate desc
CREATE view savedVersions3 as
 
select whN, saveName, MAX(createDate) createDate 
from
	(
	select tasterN whN, saveName, MAX(rowVersion) createDate from savedTables..tasting group by tasterN, saveName
	union
	select whN, saveName, MAX(rowVersion) createDate from savedTables..whToWine group by whN, saveName
	union
	select whN, saveName, MAX(rowVersion) createDate from savedTables..whToTrustedPub group by whN, saveName
	union
	select whN, saveName, MAX(rowVersion) createDate from savedTables..whToTrustedTaster group by whN, saveName
	union
	select whN, saveName, MAX(rowVersion) createDate from savedTables..BottleLocation group by whN, saveName
	union
	select whN, saveName, MAX(rowVersion) createDate from savedTables..Purchase group by whN, saveName
	union
	select whN, saveName, MAX(rowVersion) createDate from savedTables..Supplier group by whN, saveName
	) a
group by whN, saveName
 
 
 
 
 
 
