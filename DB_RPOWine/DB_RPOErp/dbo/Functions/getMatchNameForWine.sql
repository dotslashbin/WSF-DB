CREATE function [dbo].[getMatchNameForWine](@wineN int)
returns nvarchar(500)
as begin
	return (
				select  dbo.getMatchName(
							  producerShow, labelName
							, colorclass, variety
							, country, region, location, locale, [site]
							)
					from wine a join wineName b on a.wineNameN=b.wineNameN
					where a.wineN=@wineN
			)
end
