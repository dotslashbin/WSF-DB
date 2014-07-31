CREATE function [dbo].[pickFromPlaceList](@placeN int)
/*
select * from dbo.getProducerList('mo ro', '', '', '', '', '')
select * from dbo.getPlaceList('','Moreux, Roger', '', '', '', '', '')
select * from pickFromPlaceList(-88789)
*/
returns @T table(keywordHint nvarchar(200), allPlaces nvarchar(999), country nvarChar(200), region nvarChar(200), location nvarChar(200), subLocation nvarChar(200), detailedLocation nvarChar(200))
as begin
	declare @cnt int=null

	insert into @T(country, region, location, subLocation, detailedLocation)
		select country, region, location, subLocation, detailedLocation
			from masterLoc where masterLocN=@placeN;
	with 
	a as     (select * from masterLoc where masterLocN=@placeN)
	select @cnt=count(*)
		from masterLoc b,a
		where b.loc<>a.loc
			and (a.country = b.country or a.country is null)
			and (a.region = b.region or a.region is null)
			and (a.location = b.location or a.location is null)
			and (a.subLocation = b.subLocation or a.subLocation is null)
			and (a.detailedLocation = b.detailedLocation or a.detailedLocation is null);						
		 
	update @T
			set
				  keywordHint =
					case
						when @cnt=0 then '(All available place levels have been specified)'
						when @cnt=1 then 'There is an optional '+case when location is null then 'Region' else 'sub-location' end+'.  Type space to see'
						when @cnt>1 then 'There are optional '+case when location is null then 'Regions' else 'sub-locations' end+'.  Type space to see, keywords to select'
						else ''
					end
				, allPlaces =
					case when country like '%[0-z]%' then country 
						+	case when region like '%[0-z]%' then '|'+region
							+	case when location like '%[0-z]%' then '|'+location
								+	case when subLocation like '%[0-z]%' then '|'+subLocation
									+	case when detailedLocation like '%[0-z]%' then '|'+detailedLocation
										else case when @cnt>0 then '|(Detailed Location?)' end end
									else case when @cnt>0 then '|(Sublocation?)' end end
								else case when @cnt>0 then '|(Region?)' end end
							else case when @cnt>0 then '|(Region?)' end end
					else '(Country?)' end
	return 
end
 
 
 
 
 
 
 
