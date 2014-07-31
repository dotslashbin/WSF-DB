
--select * from savedVersions3 where whn=20 order by mru desc
CREATE view [dbo].[savedVersions] as
 
select whN, saveName, MAX(mru) mru 
from
	(
	select tasterN whN, saveName, MAX(rowVersion) mru from savedTables..tasting group by tasterN, saveName
	union
	select whN, saveName, MAX(rowVersion) mru from savedTables..whToWine group by whN, saveName
	union
	select whN, saveName, MAX(rowVersion) mru from savedTables..whToTrustedPub group by whN, saveName
	union
	select whN, saveName, MAX(rowVersion) mru from savedTables..whToTrustedTaster group by whN, saveName
	union
	select whN, saveName, MAX(rowVersion) mru from savedTables..Purchase group by whN, saveName
	union
	select whN, saveName, MAX(rowVersion) mru from savedTables..Supplier group by whN, saveName
	union
	select whN, saveName, max(rowVersion) mru from savedTables..location group by whN, saveName
	) a
group by whN, saveName
 
 

