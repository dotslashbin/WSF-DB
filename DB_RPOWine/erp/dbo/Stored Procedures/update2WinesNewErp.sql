
 
CREATE proc [dbo].[update2WinesNewErp] (@source nvarchar(max))
-- exec update2winesNewErp  'erp'
as begin
set nocount on;
-----------------------------------------------------------------------------------
-- Main Code
----------------------------------------------------------------------------------
declare
  @vintage varchar(4) , @producer nvarchar(100), @labelName nvarchar(150), @colorClass nvarchar(20), @variety nvarchar(100), @dryness nvarchar(500), @wineType nvarchar(500), @country nvarchar(100), @locale nvarchar(100)
, @location nvarchar(100), @region nvarchar(100), @site nvarchar(100), @comments nvarchar(max), @namerWhN nvarchar(4), @wineN int, @jWineN int,@forceWineN int,@forceVinn int, @jVinn int, @wid nvarchar(20), @wid2 nvarchar(20)
,@ignoreWidMap bit=1, @sql nvarchar(max),@useWineN bit=0
 
declare @i cursor
if @source like '%erp%'
	begin
		select @sql='set  @i2 = cursor for select  a.vintage,producer,labelName,colorClass,variety,dryness,wineType,country,locale,location,region,site,a.wineN,a.vinn,wid from vJWine a left join wine b on a.winen=b.winen  where a.wineN>0 and b.wineN is null;open @i2'
			,@ignoreWidMap=1
			,@useWineN=1
	end
else 
	begin
		if @source like '%alert%' or @source like '%julian%'
			select @sql='select vintage,producer,labelName,colorClass,variety,dryness,wineType,country,locale,location,region,site,wineN,vinn,wid from vWineJ where wineN<0;'
				,@ignoreWidMap=1
		else
			return
	end
 
exec sp_executeSQL  @sql,  N'@i2 cursor OUTPUT',@i2=@i OUTPUT
 
declare @cnt int=0
--open @i
while 1=1
	begin
		fetch next from @i into @vintage,@producer,@labelName,@colorClass,@variety,@dryness,@wineType,@country,@locale,@location,@region,@site,@jWineN,@jVinn,@wid
		if @@fetch_status <> 0 break
 
		set @cnt+=1;if 0=( @cnt%1000) exec dbo.ooLog '     @1 erp wines', @cnt
		
		if 0=@ignoreWidMap or not exists(select * from widMap where wid=@wid and vintage=@vintage and wineN>0)
			begin
				if @jVinn>0 set @forceVinn=@jVinn else set @forceVinn=null
				if @useWineN=1 and @jWineN>0 set @forceWineN=@jWineN else set @forceWineN=null
 
				exec dbo.addWine2
					1
					,@forceWineN
					,@forceVinn
					,@vintage,@producer,@labelName,@colorClass,@variety,@dryness,@wineType,@country,@locale,@location,@region,@site,@comments, 20, @wineN=@wineN output;
 
				select top 1 @wid2=wid from vWAName where vinn=@jVinn;		
				if @wid2 is null set @wid2=@wid
				
				if exists (select * from widMap where wid=@wid2 and vintage=@vintage)
					update widMap set jVinn=@jVinn,jWineN=@jWineN,wineN=@wineN where wid=@wid2 and vintage=@vintage
				else
					insert into widMap(wid, vintage,jVinn,jWineN, wineN) select @wid2, @vintage, @jVinn,@jWineN,@wineN
			
				if @wineN<>@jwineN and not exists(select * from mapJToE where jWineN=@jWineN)
					insert into mapJToE(jwinen,ewinen) select @jwinen,@winen
					
			end
	end
close @i
deallocate @i
 
exec dbo.update2Replaced
--exec dbo.updateMasterTableLocProducer null
 
end
 
 
 
 
 
 
 
 
 
 
 







