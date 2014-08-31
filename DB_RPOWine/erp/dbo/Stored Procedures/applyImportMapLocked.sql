CREATE proc [dbo].applyImportMapLocked(@whn int, @userWinesId int) as begin
-- 
-- alter view vUserWines as select * from transfer..userwines19
set nocount on
 
declare @myWineName nvarchar(999)=null, @userWinesWineN int=null, @userWinesVintage nvarchar(10) =null
	
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
	, @commentsSelectedNew nvarchar(max)='<b><small>(The Selected Wine)<br>(New Vintage)</small></b> '
 
-----------------------------------------------------------------------------------
-- Make sure all new fields are present
----------------------------------------------------------------------------------
--exec dbo.addUserWinesFields @myTableName , 'drop view vUserWines'
 
-----------------------------------------------------------------------------------
-- Update Views
---------------------------------------------------------------------------------- 
/*
begin try
	if isNull(OBJECT_DEFINITION (OBJECT_ID('dbo.vUserWines')),'') not like '%'+@myTableName
		exec ('alter view vUserWines as select * from '+@myTableName)
end try begin catch
		begin try drop view vUserWines end try begin catch end catch
	begin try	
		declare @sql nvarchar(max)
		set @sql='create view vUserWines as select * from transfer..userWines'+convert(nvarchar,@whN)
		exec (@sql)
--		exec ('create view vUserWines as select * from transfer..userWines'+'20')
	end try begin catch end catch
end catch
*/
exec alterViewUserWines @whN
 						
if @userWinesId is not null
	begin
		update vUserWines set setByUser=1 where id=@userWinesId and 1<>isnull(setByUser,0);
		select  @myWineName=myWineName, @userWinesWineN=wineN, @userWinesVintage=vintage from vUserWines where id=@userWinesId
		set @myWineName=REPLACE(@myWineName,'''','''''')		--sqlInjection protection
		if @myWineName not like '%[0-z]%' 
			return
 
		-----------------------------------------------------------------------------------
		-- Update exact matches to current wine
		----------------------------------------------------------------------------------
		update a
				set
--					  a.erpWineName=b.erpWineName
					  a.erpWineName=d.matchName
					, a.wineN=b.wineN
					--, a.rowFlag=@flagFromMyHistory
					, a.rowFlag=@flagSelectedWine 
--					, a.fromSameVintage=case when b.erpVintage=a.vintage then 1 else 0 end
--					, a.fromOtherVintage=case when b.erpVintage=a.vintage then 0 else 1 end
--					, a.comments=case when c.wineN is null then @commentsSelectedNew else @commentsSelected end
					, a.fromSameVintage=case when c.vintage=a.vintage then 1 else 0 end
					, a.fromOtherVintage=case when c.vintage=a.vintage then 0 else 1 end
					, a.comments=case when c.vintage=a.vintage then @commentsSelected else @commentsSelectedNew end
			from (select * from vUserWines where myWineName=@myWineName and vintage=@userWinesVintage) a
				join importMap b
					on b.whN=@whn 
					and b.myVintage=a.vintage 
					and b.myWineName=a.myWineName
				join wine c
					on c.wineN=b.wineN 
				join winename d
						on c.winenamen=d.winenamen;
--				join wine c
--					on c.wineN=b.wineN;
--				left join wine c
--					on c.wineN=b.wineN and c.vintage=a.vintage;
 
			--exec dbo.autoOtherVintagesLocked @myWineName;
 
			-----------------------------------------------------------------------------------
			-- Update Other Vintages
			----------------------------------------------------------------------------------
			--declare @userWinesId int=2;
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
else	
	begin
			-----------------------------------------------------------------------------------
			-- Update exact matches from History
			----------------------------------------------------------------------------------
			update a
					set
--						  a.erpWineName=b.erpWineName
						  a.erpWineName=d.matchName
						, a.wineN=b.wineN
						 , a.fromSameVintage=case when b.erpVintage=a.vintage then 1 else 0 end
						,  a.fromOtherVintage=case when b.erpVintage=a.vintage then 0 else 1 end
						,  a.presentBeforeThisCycle=1
						, a.rowFlag=@flagFromMyHistory
						, a.comments=@commentsYouMatched
				from vUserWines a
					join importMap b
						on b.whN=@whn 
						and b.myVintage=a.vintage 
						and b.myWineName=a.myWineName
					join wine c
						on c.wineN=b.wineN 
					join winename d
						on c.winenamen=d.winenamen
--					left join wine c
--						--on c.wineN=b.wineN and c.vintage=a.vintage
--					join vwineplus c
--						on c.wineN=b.wineN
					where a.wineN is null
						--or(a.wineN=@userWinesWineN and a.vintage=@userWinesVintage);
			 
			 
			 
			 
			------------------------------------------------------------------------------------------------------------------------------
			-- History Other Users
			------------------------------------------------------------------------------------------------------------------------------
			update a
					set
						  a.erpWineName=d.matchName
						, a.wineN=b.wineN
						 , a.fromSameVintage=case when c.Vintage=a.vintage then 1 else 0 end
						,  a.fromOtherVintage=case when c.Vintage=a.vintage then 0 else 1 end
						,  a.presentBeforeThisCycle=1
						, a.rowFlag=@flagFromOtherHistory
						, a.comments=@commentsOtherHistory
				--from (select * from vUserWines where myWineName like @myWineName) a
				from vUserWines a
					join (select min(d.winen) winen, min(erpwinename)erpwinename, myvintage,mywinename from importmap d
							--where winen is not null group by myvintage, mywinename having count(distinct winen)=1) b
							where winen is not null group by myvintage, mywinename having count(distinct winen)=1 and count(distinct whN)>=2) b
 
					--join (select min(d.winen) winen, min(erpwinename)erpwinename, myvintage,mywinename 
							--from importmap d
							--join wine e on d.winen=e.winen
							--where d.winen is not null group by myvintage, mywinename having count(distinct activeVinn)=1 and count(distinct whN)>=2) b
 
						on b.myVintage=a.vintage 
						and b.myWineName=a.myWineName
					join wine c
						on c.wineN=b.wineN 
					join winename d
						on c.winenamen=d.winenamen
					where a.wineN is null;
 
 
 
	end;
 
 
 
 
 
--     hasErpTasting      presentBeforeThisCycle     twoErpMatches     setByUser     fromSameVintage     fromOtherVintage
 
------------------------------------------------------------------------------------------------------------------------------
-- Update Bit isErpTasting
------------------------------------------------------------------------------------------------------------------------------
update a set hasErpTasting=case when fromSameVintage=1 and exists(select * from tasting b where b.wineN=a.wineN and isErpTasting=1) then 1 else 0 end from (select * from vUserWines where myWineName like @myWineName) a
 
end
 
 
 
 
 
 
