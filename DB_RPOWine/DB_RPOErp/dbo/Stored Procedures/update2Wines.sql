
CREATE proc [dbo].[update2Wines] (@ignoreWidMap bit=null)
as begin
set nocount on;
/*
--truncate table widMap    
select * from widMap
update2wines
 1
*/
-----------------------------------------------------------------------------------
-- Error detection
----------------------------------------------------------------------------------
declare @cntBadWid int;
 
select @cntBadWid=count(*)
	from vWineJ a
		left join vWAName b
			on a.wid=b.wid
	where a.wineN<0 and b.wid is null
if @cntBadWid>0
	begin
		print convert(nvarchar,@cntBadWid)+' wid wines with bad wid'
		return
	end;
 
with c as	(	select wid, count(distinct a.vinn)cntVinn 
					from vWAName a 
						join (select distinct vinn from vWineJ where wineN<0)b
							on a.vinn=b.vinn
					group by wid 
			)
select @cntBadWid=count(*) from c where cntVinn>1
if @cntBadWid>0
	begin
		print convert(nvarchar,@cntBadWid)+' wid with multiple vinn'
		return
	end
 
 
-----------------------------------------------------------------------------------
-- Main Code
----------------------------------------------------------------------------------
declare
	  @vintage varchar(4) 
	, @producer nvarchar(100)
	, @labelName nvarchar(150)
	, @colorClass nvarchar(20)
	, @variety nvarchar(100)
	, @dryness nvarchar(500)
	, @wineType nvarchar(500)
	, @country nvarchar(100)
	, @locale nvarchar(100)
	, @location nvarchar(100)
	, @region nvarchar(100)
	, @site nvarchar(100)
	, @comments nvarchar(max)
	, @namerWhN nvarchar(4)
	, @wineN int
	, @jWineN int
	,@forceVinn int
	, @jVinn int
	, @wid nvarchar(20)
 
declare i cursor for 
	select vintage,producer,labelName,colorClass,variety,dryness,wineType,country,locale,location,region,site,wineN,vinn,wid from vWineJ where wineN<0;
declare @cnt int=0
open i
while 1=1
	begin
		fetch next from i into @vintage,@producer,@labelName,@colorClass,@variety,@dryness,@wineType,@country,@locale,@location,@region,@site,@jWineN,@jVinn,@wid
		if @@fetch_status <> 0 break
 
		set @cnt+=1;if 0=( @cnt%1000) exec dbo.ooLog '     @1 wines done', @cnt
		
		if 0=@ignoreWidMap or not exists(select * from widMap where wid=@wid and vintage=@vintage and wineN>0)
			begin
				set @wineN=@jWineN
				
				if @jVinn>0
					set @forceVinn=@jVinn
				else	
					set @forceVinn=null
 
				exec dbo.addWine2
				1
				,null
				,@forceVinn
				,@vintage
				,@producer
				,@labelName
				,@colorClass
				,@variety
				,@dryness
				,@wineType
				,@country
				,@locale
				,@location
				,@region
				,@site
				,@comments
				, 20
				, @wineN=@wineN output;
		 		
				select top 1 @wid=wid from vWAName where vinn=@jVinn;		
				
				if exists (select * from widMap where wid=@wid and vintage=@vintage)
					update widMap set jVinn=@jVinn,jWineN=@jWineN,wineN=@wineN where wid=@wid and vintage=@vintage
				else
					insert into widMap(wid, vintage,jVinn,jWineN, wineN) select @wid, @vintage, @jVinn,@jWineN,@wineN
			end
	end
close i
deallocate i
 
exec dbo.updateMasterTableLocProducer null
 
/*
vintage
, producer
, labelName
, colorClass
, variety
, dryness
, wineType
, country
, locale
, location
, region
, site
, wineN
*/
 
end
 
 
 
 
 
 
 
 
 
 
 







