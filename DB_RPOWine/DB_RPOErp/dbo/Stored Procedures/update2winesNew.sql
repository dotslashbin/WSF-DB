CREATE proc [dbo].update2winesNew(@source nvarchar(max))
-- exec update2winesNew  'erp'
as begin
set nocount on;
exec dbo.oolog 'update2winesNew @1 begin', @source; 
-----------------------------------------------------------------------------------
-- Main Code
----------------------------------------------------------------------------------
declare
  @vintage varchar(4) , @producer nvarchar(100), @labelName nvarchar(150), @colorClass nvarchar(20), @variety nvarchar(100), @dryness nvarchar(500), @wineType nvarchar(500), @country nvarchar(100), @locale nvarchar(100)
, @location nvarchar(100), @region nvarchar(100), @site nvarchar(100), @comments nvarchar(max), @namerWhN int, @wineN int, @jWineN int,@forceWineN int,@forceVinn int, @jVinn int
,@sql nvarchar(max),@useWineN bit=0
 
declare @i cursor
if @source like '%erp%'
	begin
		select @sql='set  @i2 = cursor for select  a.vintage,producer,labelName,colorClass,variety,dryness,wineType,country,locale,location,region,site,a.wineN,a.vinn from veWine a left join wine b on a.winen=b.winen  where a.wineN>0 and b.wineN is null;open @i2'
			,@useWineN=1
			,@namerWhN=dbo.constWhMlb()
 
	end
else 
	begin
		if @source like '%alert%' or @source like '%julian%'
			select @sql='set  @i2 = cursor for select vintage,producer,labelName,colorClass,variety,dryness,wineType,country,locale,location,region,site,wineN,vinn  from vjWine where wineN<0;open @i2'
			,@useWineN=0
			,@namerWhN=dbo.constWhJb()
		else
			return
	end
 
exec sp_executeSQL  @sql,  N'@i2 cursor OUTPUT',@i2=@i OUTPUT
 
declare @cnt int=0
--open @i
while 1=1
	begin
		fetch next from @i into @vintage,@producer,@labelName,@colorClass,@variety,@dryness,@wineType,@country,@locale,@location,@region,@site,@jWineN,@jVinn
		if @@fetch_status <> 0 break
 
		set @cnt+=1;if 0=( @cnt%1000) exec dbo.ooLog '     @1 wines new', @cnt
		
				if @jVinn>0 set @forceVinn=@jVinn else set @forceVinn=null
				if @useWineN=1 and @jWineN>0 set @forceWineN=@jWineN else set @forceWineN=null
 
				exec dbo.addWine2
					1
					,@forceWineN
					,@forceVinn
					,@vintage,@producer,@labelName,@colorClass,@variety,@dryness,@wineType,@country,@locale,@location,@region,@site,@comments, @namerWhN, @wineN=@wineN output;
 
				if @wineN<>@jwineN and not exists(select * from mapJToE where jWineN=@jWineN)
					insert into mapJToE(jwinen,ewinen) select @jwinen,@winen
	end
close @i
deallocate @i
 
exec dbo.update2Replaced
--exec dbo.updateMasterTableLocProducer null
 
exec dbo.oolog 'update2winesNew @1 end', @source; 
end
 
