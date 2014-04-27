-- =============================================
-- Author:		Alex B.
-- Create date: 4/19/2014
-- Description:	Completely reload Wine table from vWine view
-- =============================================
CREATE PROCEDURE [srv].[Wine_Reload]

AS

set nocount on;
set xact_abort on;

begin try
	alter fullText Index on Wine disable;
end try
begin catch
end catch

truncate table Wine;

insert into Wine (TasteNote_ID, Wine_N_ID, Wine_VinN_ID,
	ArticleID, ArticleIdNKey,
	ColorClass,	Country, ClumpName,	Dryness, DrinkDate, DrinkDate_hi, EstimatedCost, encodedKeyWords,
	fixedId, HasWJTasting, IsActiveWineN, Issue, IsERPTasting, IsWJTasting, IsCurrentlyForSale,
	LabelName, Location, Locale, Maturity, MostRecentPrice, MostRecentPriceHi, MostRecentAuctionPrice,
	Notes,
	Producer, ProducerShow, ProducerURL, ProducerProfileFileName, ShortTitle, Publication, Places,
	Region,	Rating, RatingShow, ReviewerIdN, showForERP, showForWJ, source, SourceDate, Site,
	Vintage, Variety, VinN, WineN, WineType,
	oldIdn, oldWineN, oldVinN
)
select TasteNote_ID, Wine_N_ID, Wine_VinN_ID,
	ArticleID, ArticleIdNKey,
	ColorClass,	Country, ClumpName,	Dryness, DrinkDate, DrinkDate_hi, EstimatedCost, encodedKeyWords,
	fixedId, HasWJTasting, IsActiveWineN, Issue, IsERPTasting, IsWJTasting, IsCurrentlyForSale,
	LabelName, Location, Locale, Maturity, MostRecentPrice, MostRecentPriceHi, MostRecentAuctionPrice,
	Notes,
	Producer, ProducerShow, ProducerURL, ProducerProfileFileName, ShortTitle, Publication, Places,
	Region,	Rating, RatingShow, ReviewerIdN, showForERP, showForWJ, source, SourceDate, Site,
	Vintage, Variety, VinN, WineN, WineType,
	oldIdn, oldWineN, oldVinN
from vWine;

begin try
	alter fullText Index on Wine enable;
end try
begin catch
end catch

RETURN 1