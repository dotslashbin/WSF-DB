
--use erpTiny
CREATE function [dbo].[getPlaceList_21August2012](@keywords nvarChar(200), @country nvarChar(200), @region nvarChar(200), @location nvarChar(200), @subLocation nvarChar(200), @detailedLocation nvarChar(200))
/*
use erpTiny
set statistics time on
set statistics time off
select * from dbo.getPlaceList('n', null, 'california', null, null, null)
select * from dbo.getPlaceList('x', null, '', null, null, null)
select * from dbo.pickFromPlaceList(5596)
select * from dbo.getPlaceList('n', 'Nickel and Nickel', null, null, null, null, null)
 
*/
returns @T table(place nvarChar(200), placeN int)
as begin
	select 
		  @keywords=ltrim(rtrim(@keywords))
		, @country=ltrim(rtrim(@country))
		, @region=ltrim(rtrim(@region))
		, @location=ltrim(rtrim(@location))
		, @subLocation=ltrim(rtrim(@subLocation))
		, @detailedLocation=ltrim(rtrim(@detailedLocation))
 
	select
		@country=case when @country<>'' then @country else null end
		, @region=case when @region<>'' then @region else null end
		, @location=case when @location<>'' then @location else null end
		, @subLocation=case when @subLocation<>'' then @subLocation else null end
		, @detailedLocation=case when @detailedLocation<>'' then @detailedLocation else null end
	declare @contains nvarchar(900)=null
	
	set @contains=dbo.buildSQLContains(@keywords)
	
			if @contains is null 
				begin
					with
					a as (	select *
								from masterLoc
								where 
										len(loc)>0
										and (@country is Null or country=@country)
										and (@region is Null or region=@region)
										and (@location is Null or location=@location)
										and (@subLocation is Null or subLocation=@subLocation)
										and (@detailedLocation is Null or detailedLocation=@detailedLocation)     )
					,b as (	select top 100     loc
										, count(distinct(country)) cntCountry
										, count(distinct(Region)) cntRegion
										, count(distinct(Location)) cntLocation
										, count(distinct(SubLocation)) cntSubLocation
								from a
								group by loc     )
					insert into @T(place, placeN)
						select	case 
							when cntCountry > 1 then			
									a.loc
								+	case when country <> a.loc then ' ('+country
									+ case when region<>a.loc then ' / '+region
										+ case when location<>a.loc then ' / '+location
											+ case when subLocation<>a.loc then
												' / '+subLocation
											else '' end
										else '' end
									else '' end
									+')'				
								else '' end		
							when cntRegion > 1 then
									a.loc
								+	case when region<> a.loc then ' ('+region
										+ case when location<>a.loc then ' / '+location
											+ case when subLocation<>a.loc then
												' / '+subLocation
											else '' end
										else '' end
									+')'				
								else '' end
							when cntLocation > 1 then
									a.loc
								+	case when location<> a.loc then ' ('+location
										+ case when subLocation<>a.loc then
											' / '+subLocation
										else '' end					
									+')'				
								else '' end
							when cntSubLocation > 1 then
									a.loc
								+	case when subLocation<> a.loc then ' ('+subLocation	+')'				
								else '' end
							else
								a.loc
							end
							, masterLocN
						from a
							join b
								on a.loc = b.loc
				end
			else
				begin
					with
					a as (	select *
								from masterLoc
								where 
										len(loc)>0
										and contains(loc, @contains)
										and (@country is Null or country=@country)
										and (@region is Null or region=@region)
										and (@location is Null or location=@location)
										and (@subLocation is Null or subLocation=@subLocation)
										and (@detailedLocation is Null or detailedLocation=@detailedLocation)     )
					,b as (	select top 100     loc
										, count(distinct(country)) cntCountry
										, count(distinct(Region)) cntRegion
										, count(distinct(Location)) cntLocation
										, count(distinct(SubLocation)) cntSubLocation
								from a
								group by loc     )
					insert into @T(place, placeN)
						select	case 
							when cntCountry > 1 then			
									a.loc
								+	case when country <> a.loc then ' ('+country
									+ case when region<>a.loc then ' / '+region
										+ case when location<>a.loc then ' / '+location
											+ case when subLocation<>a.loc then
												' / '+subLocation
											else '' end
										else '' end
									else '' end
									+')'				
								else '' end		
							when cntRegion > 1 then
									a.loc
								+	case when region<> a.loc then ' ('+region
										+ case when location<>a.loc then ' / '+location
											+ case when subLocation<>a.loc then
												' / '+subLocation
											else '' end
										else '' end
									+')'				
								else '' end
							when cntLocation > 1 then
									a.loc
								+	case when location<> a.loc then ' ('+location
										+ case when subLocation<>a.loc then
											' / '+subLocation
										else '' end					
									+')'				
								else '' end
							when cntSubLocation > 1 then
									a.loc
								+	case when subLocation<> a.loc then ' ('+subLocation	+')'				
								else '' end
							else
								a.loc
							end
							, masterLocN
						from a
							join b
								on a.loc = b.loc
 
				end
	
	
		IF NOT EXISTS (SELECT * FROM @T)
		BEGIN
			DECLARE @loc NVARCHAR(200)=null
			SET @loc =	CASE 
							WHEN  @detailedLocation IS NOT NULL THEN @detailedLocation
							WHEN @subLocation IS NOT NULL THEN @subLocation
							WHEN @location IS NOT NULL THEN @Location
							WHEN @region IS NOT NULL THEN @region
							WHEN @country IS NOT NULL THEN @country
							ELSE NULL
							END
				IF @loc IS NULL
					INSERT INTO @T(place) SELECT '(No matches)'
				ELSE
					INSERT INTO @T(place) SELECT '(No matches in '+@loc+')'
		END

	
	return 
end
 
 
 
 
 
 
 
 
 
 
 

