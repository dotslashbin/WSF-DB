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
	[isAuction], [isOverridePriceException], [ErrorsOnReadin], [retailerN])
select [IdN], [Wid], [WineN], [isTempWineN], [isWineNDeduced], [WineN2], [VinN2], [Vintage], [BottleSize],
	[Price], [Currency], [isTrue750Bottle], [DollarsPer750Bottle], [TaxNotes], [URL], [RetailerDescriptionOfWine],
	[RetailerIdN], [RetailerCode], [RetailerName], [Country], [State], [City], [Errors], [Warnings],
	[isAuction], [isOverridePriceException], [ErrorsOnReadin], [retailerN]
from dbo.SYN_t_ForSaleDetail;

truncate table Retailers;

insert into Retailers(
	[RetailerIdN], [retailerN], [RetailerCode], [RetailerName], [Address], [City], [State], [Zip], [Country],
	[ShipToCountry], [Phone], [Fax], [Email], [URL], [Errors], [Warnings], [ErrorsOnReadin])
select [RetailerIdN], [retailerN], [RetailerCode], [RetailerName], [Address], [City], [State], [Zip], [Country],
	[ShipToCountry], [Phone], [Fax], [Email], [URL], [Errors], [Warnings], [ErrorsOnReadin]
from dbo.SYN_t_Retailers;
	
RETURN 1