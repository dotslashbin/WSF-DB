CREATE proc [dbo].[afterPick2](@whn int, @userWinesId int) as begin
--------------------------------------------------------------
--Debug
----------------------------------------------------------------
	exec dbo.oolog 'afterPick2 top (@1, @2)',@whn,@userwinesid
--------------------------------------------------------------
--Debug
----------------------------------------------------------------
 
/*------------------------------------------------------------------------------------------------------------------------------
use erp
exec dbo.setupImportTest	
update transfer..userwines20 set erpwinename='<b>2003 Varaldo Barolo Vigna di Aldo (Red, Barolo) </b>',wineN=114281,myVintage='          ' where id=1
exec dbo.afterPick2 -20,1	
select * into df  from transfer..userWines20
 
select * from transfer..userWines20 where id=1
union
select * from df where id=1
 
drop table df
select * from importMap
exec dbo.applyImportMap2 20,'%'
*/
 
set nocount on
 
 
-----------------------------------------------------------------------------------
-- Code
----------------------------------------------------------------------------------
declare @myImportTable nvarchar(max) = ' transfer..UserWines'+convert(nvarchar,@whn)
			, @flagSelectedWine int = 7
			, @flagGoodMatch int = 4	--7     --20     --7     --17
			, @flagFromMyHistory int = 1     --19
			, @flagFromOtherHistory int = 10     --24
			, @flagNotThere int = 4
			, @flagClash int = 5
			, @approvedThisCycle int=23
-----------------------------------------------------------------------------------
-- Make sure all new fields are present
----------------------------------------------------------------------------------
--declare @whn int=20, @userWinesId int=2
exec dbo.addUserWinesFields @myImportTable , 'drop view vUserWines; drop view vu'
 
-----------------------------------------------------------------------------------
-- Update Views
---------------------------------------------------------------------------------- 
begin try
	if isNull(OBJECT_DEFINITION (OBJECT_ID('dbo.vUserWines')),'') not like '%'+@myImportTable
		exec ('alter view vUserWines as select * from '+@myImportTable)
end try begin catch
		begin try drop view vUserWines end try begin catch end catch
	begin try												     
		declare @sql nvarchar(max)='create view vUserWines as select * from transfer..userWines'+convert(nvarchar,@whN)
		exec (@sql)
	end try begin catch end catch
end catch;
 
 
 
-----------------------------------------------------------------------------------
-- Set bits / grab myWineName
----------------------------------------------------------------------------------
declare @myWineName nvarchar(max), @wineN int, @erpWineName nvarchar(999), @vintage nvarchar(10)
update a
		set 
			  @myWineName =a.myWineName
			 , @wineN=a.wineN
			 , @erpWineName=b.matchName 
			 , @vintage=b.vintage
			, setByUser=1
			 ,fromSameVintage=case when a.myVintage=b.vintage then 1 else 0 end
			, fromOtherVintage=case when a.myVintage=b.vintage then 0 else 1 end
	from vUserWines a
		join vWinePlus b
			on a.wineN=b.wineN
	where id=@userWinesId;
 
 
 
begin try
	if isnull(OBJECT_DEFINITION (OBJECT_ID('dbo.vu')),'') not like '%'''+@myWineName +'''%'
		exec ('alter view vu as select * from vUserWines where myWineName='''+@myWineName+'''')
end try 
begin catch
	begin try 
		drop view vu 
	end try 
	begin catch end catch
	
	begin try												     
			exec ('create view vu as select * from vUserWines where myWineName='''+@myWineName+'''')
	end try begin catch end catch
end catch
 
 
 
 
-----------------------------------------------------------------------------------
-- copy userWines to importMap
----------------------------------------------------------------------------------
if exists(select *		from importMap a														       
							join vu b on a.whN=@whn and a.myVintage=b.vintage and a.myWineName=b.myWineName
						where b.id=@userWinesId     )
	begin
		if exists(select *		from importMap a														       
									join vu b on a.whN=@whn and a.myVintage=b.vintage and a.myWineName=b.myWineName and a.wineN=b.wineN
								where b.id=@userWinesId     )
			begin
				update a 
						set a.erpWineName=dbo.getMatchNameForWine(b.wineN),isOld=0
					from importMap a
						join vu b on a.whN=@whn and a.myVintage=b.vintage and a.myWineName=b.myWineName
					where b.id=@userWinesId
			end
		else
			begin
				update a 
						set a.isOld=1
					from importMap a
						join vu b on a.whN=@whn and a.myVintage=b.vintage and a.myWineName=b.myWineName
					where b.id=@userWinesId
			end
	end
else
	begin
		insert into importMap( whN, myVintage, myWineName, erpVintage, erpWineName, wineN, alreadyThere,isOld)
			select @whN, a.vintage, a.myWineName, b.vintage, dbo.getMatchNameForWine(b.wineN), b.wineN, 0,0
				from vu a
					join wine b on a.wineN=b.wineN
					where a.id=@userWinesId     
	end;
 
 
exec dbo.applyImportMap2 @whN, @userWinesId
 
 
/*-----------------------------------------------------------------------------------
-- debug
----------------------------------------------------------------------------------
select 'return to afterPick          select ** from (select * from vUserWines where myWineName like @myWineName)'
select id,vintage,mywinename,erpwinename,wineN,rowflag from (select * from vUserWines where myWineName like @myWineName)a;
return;
----------------------------------------------------------------------------------
 */
 
						
						
 
 
-----------------------------------------------------------------------------------
-- Vintages wanted but not there
----------------------------------------------------------------------------------
declare @userWinesWineN  int ,@userWinesVintage nvarchar(10);
select @userWinesWineN =wineN, @userWinesVintage=vintage from vUserWines where id=@userWinesId
update vUserWines
		set		  rowFlag=@flagNotThere 
				, wineN=@userWinesWineN 
				, erpWineName=@erpWineName
--				, comments=' <b><small>(Vintage Not Yet There)</small></b>'
				, comments=' <b><small>(New Vintage)</small></b>'
				, fromSameVintage=case when vintage=@vintage then 1 else 0 end
				, fromOtherVintage=case when vintage=@vintage  then 0 else 1 end
	--where wineN is null and rowFlag is null;
	where rowFlag is null and myWineName like @myWineName;
 
 
 
--------------------------------------------------------------
--Debug
----------------------------------------------------------------
	exec dbo.oolog 'afterPick2 bottom (@1, @2)',@whn,@userwinesid
--------------------------------------------------------------
--Debug
----------------------------------------------------------------
end
 
