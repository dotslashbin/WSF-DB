CREATE function [dbo].[getWine]
/*
use erpTiny
select * from dbo.getWine('1950','','','','','','','','','','','')
*/
					(
						@vintage nvarchar(4)
						, @producer nvarchar(200)
						, @labelName nvarchar(200)
						, @variety nvarchar(200)
						, @colorClass nvarchar(200)
						, @wineType nvarchar(200)
						, @dryness nvarchar(200)
						, @country nvarChar(200)
						, @region nvarChar(200)
						, @location nvarChar(200)
						, @subLocation nvarChar(200)
						, @detailedLocation nvarChar(200)
					)
/*
*/
returns @T table(
						wineN int
						, vintage nvarchar(4)
						, producer nvarchar(200)
						, labelName nvarchar(200)
						, variety nvarchar(200)
						, colorClass nvarchar(200)
						, wineType nvarchar(200)
						, dryness nvarchar(200)
						, country nvarChar(200)
						, region nvarChar(200)
						, location nvarChar(200)
						, subLocation nvarChar(200)
						, detailedLocation nvarChar(200)
					)
 
as begin
	select
		@vintage=ltrim(rtrim(@vintage))
		, @producer=ltrim(rtrim(@producer))
		, @labelName=ltrim(rtrim(@labelName))
		, @variety=ltrim(rtrim(@variety))
		, @colorClass=ltrim(rtrim(@colorClass))
		, @wineType=ltrim(rtrim(@wineType))
		, @dryness=ltrim(rtrim(@dryness))
		, @country=ltrim(rtrim(@country))
		, @region=ltrim(rtrim(@region))
		, @location=ltrim(rtrim(@location))
		, @subLocation=ltrim(rtrim(@subLocation))
		, @detailedLocation=ltrim(rtrim(@detailedLocation))
 
	select
		@vintage=case when @vintage<>'' then @vintage else null end
		, @producer=case when @producer<>'' then @producer else null end
		, @labelName=case when @labelName<>'' then @labelName else null end
		, @variety=case when @variety<>'' then @variety else null end
		, @colorClass=case when @colorClass<>'' then @colorClass else null end
		, @wineType=case when @wineType<>'' then @wineType else null end
		, @dryness=case when @dryness<>'' then @dryness else null end
		, @country=case when @country<>'' then @country else null end
		, @region=case when @region<>'' then @region else null end
		, @location=case when @location<>'' then @location else null end
		, @subLocation=case when @subLocation<>'' then @subLocation else null end
		, @detailedLocation=case when @detailedLocation<>'' then @detailedLocation else null end
 
	insert into @T(wineN, vintage, producer, labelName, variety, colorClass, wineType, dryness, country, region, location, subLocation, detailedLocation)
		select top 10 wineN, vintage, producer, labelName, variety, colorClass, wineType, dryness, country, region, location, locale, site
			from wineName a
				join wine b
					on a.wineNameN=b.wineNameN
			where 
				(b.vintage is not null and (@vintage is null or b.vintage=@vintage))
				and (a.producer is not null and (@producer is null or a.producer=@producer))
				and (@labelName is null or a.labelName=@labelName)
				and (@variety is null or a.variety=@variety)
				and (@colorClass is null or a.colorClass=@colorClass)
				and (@wineType is null or a.wineType=@wineType)
				and (@dryness is null or a.dryness=@dryness)
				and (@country is null or a.country=@country)
				and (@region is null or a.region=@region)
				and (@location is null or a.location=@location)
				and (@subLocation is null or a.locale=@subLocation)
				and (@detailedLocation is null or a.site=@detailedLocation)
	return 
end
 
 
 
 
 
 
 
