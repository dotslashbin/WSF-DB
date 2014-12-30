-- =============================================
-- Author:		Alex B.
-- Create date: 9/10/2014
-- Description:	Reloads ForSaleDetail and Retailers from RPOSearch Database.
-- =============================================
CREATE PROCEDURE [srv].[Reload_FromSearchDB]
	
--
-- @IsFullReload = 1 --> truncates data in Wine table and completely reloads it.
-- @IsFullReload = 0 --> merges data
--

AS

set nocount on;
set xact_abort on;

truncate table ForSaleDetail;

insert into ForSaleDetail(
	[IdN], [Wid], [WineN], [isTempWineN], [isWineNDeduced], [WineN2], [VinN2], [Vintage], [BottleSize],
	[Price], [Currency], [isTrue750Bottle], [DollarsPer750Bottle], [TaxNotes], [URL], [RetailerDescriptionOfWine],
	[RetailerIdN], [RetailerCode], [RetailerName], [Country], [State], [City], [Errors], [Warnings],
	[isAuction], [isOverridePriceException], [ErrorsOnReadin], [retailerN],
	Wine_VinN_ID, WineNOriginal)
select [IdN], sd.[Wid], 
	[WineN] = case when sd.WineN > 0 and winen.ID is NOT NULL then sd.WineN else isnull(wn.ID, sd.WineN) end, 
	[isTempWineN], [isWineNDeduced], [WineN2], [VinN2], sd.[Vintage], [BottleSize],
	[Price], [Currency], [isTrue750Bottle], [DollarsPer750Bottle], [TaxNotes], [URL], [RetailerDescriptionOfWine],
	[RetailerIdN], [RetailerCode], [RetailerName], [Country], [State], [City], [Errors], [Warnings],
	[isAuction], [isOverridePriceException], [ErrorsOnReadin], [retailerN],
	vn.Wine_VinN_ID, sd.WineN
from dbo.SYN_t_ForSaleDetail sd
	left join (select Wid, Wine_VinN_ID from dbo.SYN_t_WAName) vn on sd.Wid = vn.Wid
	left join (
		select wn.ID, Wine_VinN_ID, Vintage = vin.Name 
		from Wine_N wn (nolock) 
			join WineVintage vin (nolock) on wn.VintageID = vin.ID
	) wn on vn.Wine_VinN_ID = wn.Wine_VinN_ID and isnull(sd.Vintage, '') = wn.Vintage
	  
	left join WineVintage wvin (nolock) on isnull(sd.Vintage, '') = wvin.Name
	left join Wine_N winen (nolock) on sd.WineN = winen.ID and wvin.ID = winen.VintageID
;

truncate table Retailers;

insert into Retailers(
	[RetailerIdN], [retailerN], [RetailerCode], [RetailerName], [Address], [City], [State], [Zip], [Country],
	[ShipToCountry], [Phone], [Fax], [Email], [URL], [Errors], [Warnings], [ErrorsOnReadin])
select [RetailerIdN], [retailerN], [RetailerCode], [RetailerName], [Address], [City], [State], [Zip], [Country],
	[ShipToCountry], [Phone], [Fax], [Email], [URL], [Errors], [Warnings], [ErrorsOnReadin]
from dbo.SYN_t_Retailers;
	
RETURN 1