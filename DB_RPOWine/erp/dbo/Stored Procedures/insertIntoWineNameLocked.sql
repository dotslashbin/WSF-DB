
CREATE proc [dbo].insertIntoWineNameLocked (
	@activeVinn int=null
	, @producer nvarchar(100)
	, @labelName nvarchar(150)
	, @colorClass nvarchar(20)
	, @variety nvarchar(100)
	, @dryness nvarchar(500)
	, @wineType nvarchar(500)
	, @country nvarchar(100)
	, @region nvarchar(100)
	, @location nvarchar(100)
	, @locale nvarchar(100)
	, @site nvarchar(100)
	, @namerWhN nvarchar(4)
	, @joinX varchar(max)
	, @wineNameN int output     )
 
as begin
	declare @date smallDatetime =getDate()
 
	set identity_insert wine on
	insert into wineName (activeVinn, Producer, producerShow, labelName, colorClass, country, region, location, locale, site, variety, wineType, dryness, createDate,namerwhN, joinx
							, encodedKeywords, matchName     )
		select @activeVinn, @Producer, dbo.convertSurname(@Producer), @labelName, @colorClass, @country, @region, @location, @locale, @site, @variety, @wineType, @dryness, @date, @namerWhN, @joinx
			 , case when @producer is null then '' else dbo.convertSurname(@producer) + ' ' end
			 + case when @labelName is null then '' else @labelName + ' ' end
			 + case when @dryness is null then '' else @dryness + ' ' end
			 + case when @colorClass is null then '' else @colorClass + ' ' end
			 + case when @wineType is null then '' else @wineType + ' ' end
			 + case when @variety is null then '' else @variety + ' ' end
			 + case when @country is null then '' else @country + ' ' end
			 + case when @region is null then '' else @region + ' ' end
			 + case when @location is null then '' else @location + ' ' end
			 + case when @locale is null then '' else @locale + ' ' end
			 + case when @site is null then '' else @site + ' ' end
			, dbo.getMatchName(dbo.convertSurname(@Producer),@labelName,@colorClass,@variety,@country,@region,@location,@locale,@site) ;
 
	select @wineNameN=scope_identity()
	set identity_insert wine off
end
 
 
 
 
 
 
 
 










