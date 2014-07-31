create proc [dbo].[applyOtherVintagesLocked](@whN int, @myWineName nvarchar(999)) as begin
-----------------------------------------------------------------------------------
-- Update Other Vintages
----------------------------------------------------------------------------------
--declare @userWinesId int=2;
 
declare @myTableName nvarchar(max) = ' transfer..UserWines'+convert(nvarchar,@whn)
			, @flagSelectedWine int = 7
			, @flagGoodMatch int = 4	--7     --20     --7     --17
			, @flagFromMyHistory int = 1     --19
			, @flagFromOtherHistory int = 10     --24
			, @flagNotThere int = 4
			, @flagClash int = 5
			, @approvedThisCycle int=23
	
declare @comments nvarchar(max)
	, @commentsYouMatched nvarchar(max)=' <b><small>(You Matched This Before)</small></b>'
	, @commentsOtherVintage nvarchar(max)='<b><small>(Additional  Vintage)</small></b>'
	, @commentsOtherHistory nvarchar(max)='<b><small>(Other Users Matched This)</small></b>'
	, @commentsSelected nvarchar(max)=' <b><small>(The Selected Wine)</small></b> '
	, @commentsSelectedNew nvarchar(max)='<b><small>(The Selected Wine)<br>(New Vintage)</small></b> ';
 
with
aWinesWanted as	(Select myWineName,Vintage from vUserWines where myWineName like @myWineName group by myWineName,Vintage     )
,bWinesAvailable as
	(
			select c.myWineName,d.vintage,d.wineN, d.activeVinn,d.matchName
				from (
						select myWineName, b.matchName
							from (select * from vUserWines where myWineName like @myWineName) a
								join vWinePlus b
									on a.wineN=b.wineN
							where setByUser=1
							group by myWineName, b.matchName
					) c
					join vWinePlus d
						on c.matchName=d.matchName
				--where		
		union
			select c.myWineName,d.vintage,d.wineN, d.activeVinn,d.matchName
				from (
						select myWineName, b.activeVinn
							from (select * from vUserWines where myWineName like @myWineName) a
								join vWinePlus b
									on a.wineN=b.wineN
							where setByUser=1
							group by myWineName, b.activeVinn
					) c
					join vWinePlus d
						on c.activeVinn=d.activeVinn
	)
,cBestMatch as
	(
		select a.myWineName,a.vintage,max(a.wineN)wineN, max(a.matchName)matchName, count(distinct a.wineN)cntWineN
		from bWinesAvailable a
			join aWinesWanted b
				on a.myWineName=b.myWineName and a.vintage=b.vintage
		group by a.myWineName,a.vintage
	)
update a
		set 
			a.wineN = case when b.cntWineN=1 then b.wineN else null end 
			, a.twoErpMatches = case when b.cntWineN=1 then 0 else 1 end 
			, a.rowFlag= case b.cntWineN when 0 then @flagNotThere when 1 then @flagGoodMatch else @flagClash end 
			, fromSameVintage=0
			, a.erpWineName = case when b.cntWineN=1 then b.matchName else null end 
			, comments=case when b.cntWineN=1 then @commentsOtherVintage when b.cntWineN > 1 then '<b><small>(Multiple ERP Matches<br>Use Select to choose)</small><b>'  else null end
 
	from (select * from vUserWines where myWineName like @myWineName) a
		join cBestMatch b
			on a.myWineName=b.myWineName and a.vintage=b.vintage
	where a.wineN is Null;
 
end
