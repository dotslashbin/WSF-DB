
CREATE proc [dbo].[addWine] (
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
	, @wineN int output
	)
as begin
set nocount on
declare @date smallDatetime =getDate(), @lock int
			, @joinX varchar(max)=null, @vinn int=null, @wineNameN int=null,@wineNThisVinn int = null
 
set @wineN=null
 
if @vintage like '%N%V%' set @vintage='NV'
set @vintage = dbo.normalizeName(@vintage)
 
set @producer = dbo.normalizeName(@producer)
set @labelName = dbo.normalizeName(@labelName)
set @country = dbo.normalizeName(@country)
set @region = dbo.normalizeName(@region)
set @locale = dbo.normalizeName(@locale)
set @site = dbo.normalizeName(@site)
set @variety = dbo.normalizeName(@variety)
set @colorClass = dbo.normalizeName(@colorClass)
set @dryness = dbo.normalizeName(@dryness)
set @wineType = dbo.normalizeName(@wineType)
 
begin transaction
exec @lock = sp_getapplock @resource='addNewWine', @lockmode='Exclusive'
if @lock<0
	begin
			rollback transaction
			set @wineN=null
	end
else
	begin
			set @joinX = dbo.getJoinX(@Producer, @labelName, @colorClass,  @country,  @region, @location,  @locale,  @site,  @variety, @wineType,  @dryness)
			select top 1 @wineNameN=wineNameN, @vinn = activeVinn from wineName where joinX=@joinX order by dateHi desc
			if @wineNameN is null
				begin
					--print 'Wine Name not found'
					set @vinn=dbo.getNewVinn()
					insert into wineName (activeVinn, Producer, producerShow, labelName, colorClass, country, region, location, locale, site, variety, wineType, dryness, createDate,namerwhN, joinx
											, encodedKeywords     )
						select @vinn, @Producer, dbo.convertSurname(@Producer), @labelName, @colorClass, @country, @region, @location, @locale, @site, @variety, @wineType, @dryness, @date, @namerWhN, @joinx
											, case when @vintage is null then '' else @vintage + ' ' end
											 + case when @producer is null then '' else dbo.convertSurname(@producer) + ' ' end
											 + case when @labelName is null then '' else @labelName + ' ' end
											 + case when @dryness is null then '' else @dryness + ' ' end
											 + case when @colorClass is null then '' else @colorClass + ' ' end
											 + case when @wineType is null then '' else @wineType + ' ' end
											 + case when @variety is null then '' else @variety + ' ' end
											 + case when @country is null then '' else @country + ' ' end
											 + case when @region is null then '' else @region + ' ' end
											 + case when @location is null then '' else @location + ' ' end
											 + case when @locale is null then '' else @locale + ' ' end
											 + case when @site is null then '' else @site + ' ' end;
			 
					select @wineNameN=scope_identity()
					
					--print '@vinn='+isnull(convert(varchar,@vinn),'Null Vinn')
					exec dbo.wineForVintageVinn null, @vinn, @wineNameN, @vintage, @newWineN=@wineN output
				end
			else
				begin
					if @vinn is  null 
						begin
							set @vinn=dbo.getNewVinn()
							update wineName set activeVinn=@vinn where wineNameN=@wineNameN
							--print 'WineName found but no Vinn.  NewVinn created for WineNameN:' + convert(varchar,@wineNameN)
						end
					select top 1 @wineN=wineN from wine where vintage=@vintage and activeVinn=@vinn order by activeVinn desc
					if @wineN is  null 
						begin
							--print 'wineN is null'
							select top 1 @wineNThisVinn=wineN from wine where activeVinn=@vinn order by wineN
							exec dbo.wineForVintageVinn @wineNThisVinn, @vinn, @wineNameN, @vintage, @newWineN = @wineN output
							--print 'WineName found, newWineN=' + convert(varchar, isnull(@wineN, 'null'))
						end
				end
			 
			exec sp_releaseAppLock @resource='addNewWine'
			commit transaction
	end 
 
 
end
/*
declare @wineN int=null;
exec dbo.addWine
	  '1598'     --@vintage varchar(4) 
	, 'blastoPlasto'	-- @producer nvarchar(100)
	, 'pigs'--null     --@labelName nvarchar(150)
	, null     --@colorClass nvarchar(20)
	, null     --@variety nvarchar(100)
	, null     --@dryness nvarchar(500)
	, null     --@wineType nvarchar(500)
	, null     --@country nvarchar(100)
	, null     --@locale nvarchar(100)
	, null     --@location nvarchar(100)
	, null     --@region nvarchar(100)
	, null     --@site nvarchar(100)
	, null     --@comments nvarchar(max)
	, 99     --@namerWhN nvarchar(4)
	, @wineN=@wineN output;
print @wineN
 
 declare @wineN int=null;
exec dbo.addWine
	  '1990'     --@vintage varchar(4) 
	, 'xxAalto'	-- @producer nvarchar(100)
	, null     --@labelName nvarchar(150)
	, null     --@colorClass nvarchar(20)
	, null     --@variety nvarchar(100)
	, null     --@dryness nvarchar(500)
	, null     --@wineType nvarchar(500)
	, null     --@country nvarchar(100)
	, null     --@locale nvarchar(100)
	, null     --@location nvarchar(100)
	, null     --@region nvarchar(100)
	, null     --@site nvarchar(100)
	, null     --@comments nvarchar(max)
	, 20     --@namerWhN nvarchar(4)
	, @wineN=@wineN output;
print @wineN
 
 
select top 10 * from wineName order by wineNameN desc
select * from wine where wineNameN= 1971034
select * from wine order by rowVersion desc
select * from wine where wineN=2099999098
select max(activeVinn) from wine
 
delete from wineName where namerWhN=99
	
print @wineN
 
*/
 
 
