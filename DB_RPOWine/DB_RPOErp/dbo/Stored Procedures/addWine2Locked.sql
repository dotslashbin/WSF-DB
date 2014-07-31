
CREATE proc [dbo].addWine2Locked (
	@delayMasterlistUpdate bit=0
	 , @forceWineN int=null
	, @forceVinn int=null
	, @vintage varchar(4) 
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
	, @namerWhN int
	, @wineN int output
	)
as begin
	set nocount on
	declare @date smallDatetime =getDate()
				, @joinX varchar(max)=null, @vinn int=null, @wineNameN int=null,@wineNThisVinn int = null
				, @priorNamerWhN int=-1
	 
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
 
	set @joinX = dbo.getJoinX(@Producer, @labelName, @colorClass,  @country,  @region, @location,  @locale,  @site,  @variety, @wineType,  @dryness)
	select top 1 @wineNameN=wineNameN, @vinn = activeVinn, @priorNamerWhN=namerWhN  from wineName where joinX=@joinX order by dateHi desc
	if @wineNameN is null
		begin
			if @forceVinn is null
				set @vinn=dbo.getNewVinn()
			else
				set @vinn=@forceVinn
 
			exec dbo.insertIntoWineName @vinn, @producer, @labelName, @colorClass, @variety, @dryness, @wineType, @country, @region, @location, @locale, @site, @namerWhN, @joinX, @wineNameN=@wineNameN output
			/*if @vintage is not null
				begin
					if @forceWineN is not null
						set @wineN=@forceWineN
					else
						exec dbo.wineForVintageVinn	 null, @vinn, @wineNameN, @vintage, @newWineN=@wineN output
				end*/
		end
	else		
		begin
			if @forceVinn is null
				begin
					if @vinn is null
						begin
							set @vinn=dbo.getNewVinn()
							update wineName set activeVinn=@vinn where wineNameN=@wineNameN
						end
				end
			else
				begin
					if @vinn is null or @vinn<>@forceVinn
						begin
							set @vinn=@forceVinn
							update wineName set activeVinn=@vinn where wineNameN=@wineNameN
						end
				end
			
			if @priorNamerWhN is null
					update wineName set namerWhN=@namerWhN  where wineNameN=@wineNameN
			else
				begin
					if @namerWhN<>@priorNamerWhN
						begin
							if @namerWhN in (dbo.constWhMlb(),dbo.constWhJb())
								update wineName set namerWhN=@namerWhN  where wineNameN=@wineNameN
						end
				end
		end
		
		if @vintage is not null
			begin
				if @forceWineN is not null
					begin
						if not exists(select wineN from wine where wineN=@forceWineN)
							begin
								exec dbo.insertIntoWine @forceWineN, @vinn, @wineNameN, @vintage
								set @wineN = @forceWineN
							end
					end
				else
					begin
						select top 1 @wineN=wineN from wine where vintage=@vintage and activeVinn=@vinn order by activeVinn desc
						if @wineN is  null 
							begin
								select top 1 @wineNThisVinn=wineN from wine where activeVinn=@vinn order by wineN
								exec dbo.wineForVintageVinn @wineNThisVinn, @vinn, @wineNameN, @vintage, @newWineN = @wineN output
							end
					end
			end		
	 
	--if @vintage is nll return negative wineNameN
	if @vintage is null
		set @wineN=-@wineNameN
 
	if 0=@delayMasterlistUpdate 
		begin
			exec dbo.updateMasterTableLocProducer @wineNameN
		end
end
 
 







