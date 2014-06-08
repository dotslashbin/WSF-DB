-- =============================================
-- Author:		Alex B.
-- Create date: 4/19/2014
-- Description:	Completely reload Wine table from vWine view
-- =============================================
CREATE PROCEDURE [srv].[Wine_Reload]
	@IsFullReload bit = 0
	
--
-- @IsFullReload = 1 --> truncate data in Wine table and completely reload it.
-- @IsFullReload = 0 --> merges data
--

AS

set nocount on;
set xact_abort on;

begin try
	alter fullText Index on Wine disable;
end try
begin catch
end catch

if @IsFullReload = 1 begin
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
		oldIdn, oldWineN, oldVinN, RV_TasteNote, RV_Wine_N
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
		oldIdn, oldWineN, oldVinN, RV_TasteNote, RV_Wine_N
	from vWine;
	
end else begin

	declare @Res table(
		Act varchar(10),
		ID int);

	merge Wine as t
	using (
		select TasteNote_ID, Wine_N_ID, Wine_VinN_ID,
			ArticleID, ArticleIdNKey,
			ColorClass,	Country, ClumpName,	Dryness, DrinkDate, DrinkDate_hi, EstimatedCost, encodedKeyWords,
			fixedId, HasWJTasting, IsActiveWineN, Issue, IsERPTasting, IsWJTasting, IsCurrentlyForSale,
			LabelName, Location, Locale, Maturity, MostRecentPrice, MostRecentPriceHi, MostRecentAuctionPrice,
			Notes,
			Producer, ProducerShow, ProducerURL, ProducerProfileFileName, ShortTitle, Publication, Places,
			Region,	Rating, RatingShow, ReviewerIdN, showForERP, showForWJ, source, SourceDate, Site,
			Vintage, Variety, VinN, WineN, WineType,
			oldIdn, oldWineN, oldVinN, RV_TasteNote, RV_Wine_N
		from vWine
	) as s on t.TasteNote_ID = s.TasteNote_ID and t.Wine_N_ID = s.Wine_N_ID and t.Wine_VinN_ID = s.Wine_VinN_ID
	when matched 
		and (t.RV_TasteNote != s.RV_TasteNote or t.RV_Wine_N != s.RV_Wine_N)
	then
		UPDATE set
			ArticleID = isnull(s.ArticleID, t.ArticleID), 
			ArticleIdNKey = isnull(s.ArticleIdNKey, t.ArticleIdNKey),
			ColorClass = isnull(s.ColorClass, t.ColorClass),	
			Country = isnull(s.Country, t.Country), 
			ClumpName = isnull(s.ClumpName, t.ClumpName),
			Dryness = isnull(s.Dryness, t.Dryness),
			DrinkDate = isnull(s.DrinkDate, t.DrinkDate), 
			DrinkDate_hi = isnull(s.DrinkDate_hi, t.DrinkDate_hi), 
			EstimatedCost = isnull(s.EstimatedCost, t.EstimatedCost), 
			encodedKeyWords = isnull(s.encodedKeyWords, t.encodedKeyWords),
			fixedId = isnull(s.fixedId, t.fixedId), 
			HasWJTasting = isnull(s.HasWJTasting, t.HasWJTasting), 
			IsActiveWineN = isnull(s.IsActiveWineN, t.IsActiveWineN), 
			Issue = isnull(s.Issue, t.Issue), 
			IsERPTasting = isnull(s.IsERPTasting, t.IsERPTasting), 
			IsWJTasting = isnull(s.IsWJTasting, t.IsWJTasting), 
			IsCurrentlyForSale = isnull(s.IsCurrentlyForSale, t.IsCurrentlyForSale),
			LabelName = isnull(s.LabelName, t.LabelName), 
			Location = isnull(s.Location, t.Location), 
			Locale = isnull(s.Locale, t.Locale), 
			Maturity = isnull(s.Maturity, t.Maturity), 
			MostRecentPrice = isnull(s.MostRecentPrice, t.MostRecentPrice), 
			MostRecentPriceHi = isnull(s.MostRecentPriceHi, t.MostRecentPriceHi), 
			MostRecentAuctionPrice = isnull(s.MostRecentAuctionPrice, t.MostRecentAuctionPrice),
			Notes = isnull(s.Notes, t.Notes),
			Producer = isnull(s.Producer, t.Producer), 
			ProducerShow = isnull(s.ProducerShow, t.ProducerShow), 
			ProducerURL = isnull(s.ProducerURL, t.ProducerURL), 
			ProducerProfileFileName = isnull(s.ProducerProfileFileName, t.ProducerProfileFileName), 
			ShortTitle = isnull(s.ShortTitle, t.ShortTitle), 
			Publication = isnull(s.Publication, t.Publication), 
			Places = isnull(s.Places, t.Places),
			Region = isnull(s.Region, t.Region),	
			Rating = isnull(s.Rating, t.Rating), 
			RatingShow = isnull(s.RatingShow, t.RatingShow), 
			ReviewerIdN = isnull(s.ReviewerIdN, t.ReviewerIdN), 
			showForERP = isnull(s.showForERP, t.showForERP), 
			showForWJ = isnull(s.showForWJ, t.showForWJ), 
			source = isnull(s.source, t.source), 
			SourceDate = isnull(s.SourceDate, t.SourceDate), 
			Site = isnull(s.Site, t.Site),
			Vintage = isnull(s.Vintage, t.Vintage), 
			Variety = isnull(s.Variety, t.Variety), 
			VinN = isnull(s.VinN, t.VinN), 
			WineN = isnull(s.WineN, t.WineN), 
			WineType = isnull(s.WineType, t.WineType),
			oldIdn = isnull(s.oldIdn, t.oldIdn), 
			oldWineN = isnull(s.oldWineN, t.oldWineN), 
			oldVinN = isnull(s.oldVinN, t.oldVinN),
			RV_TasteNote = isnull(nullif(s.RV_TasteNote, 0x00), t.RV_TasteNote), 
			RV_Wine_N = isnull(nullif(s.RV_Wine_N, 0x00), t.RV_Wine_N)
	when not matched by target then
		INSERT (TasteNote_ID, Wine_N_ID, Wine_VinN_ID,
			ArticleID, ArticleIdNKey,
			ColorClass,	Country, ClumpName,	Dryness, DrinkDate, DrinkDate_hi, EstimatedCost, encodedKeyWords,
			fixedId, HasWJTasting, IsActiveWineN, Issue, IsERPTasting, IsWJTasting, IsCurrentlyForSale,
			LabelName, Location, Locale, Maturity, MostRecentPrice, MostRecentPriceHi, MostRecentAuctionPrice,
			Notes,
			Producer, ProducerShow, ProducerURL, ProducerProfileFileName, ShortTitle, Publication, Places,
			Region,	Rating, RatingShow, ReviewerIdN, showForERP, showForWJ, source, SourceDate, Site,
			Vintage, Variety, VinN, WineN, WineType,
			oldIdn, oldWineN, oldVinN, RV_TasteNote, RV_Wine_N
		)
		values(s.TasteNote_ID, s.Wine_N_ID, s.Wine_VinN_ID,
			s.ArticleID, s.ArticleIdNKey,
			s.ColorClass, s.Country, s.ClumpName, s.Dryness, s.DrinkDate, s.DrinkDate_hi, s.EstimatedCost, s.encodedKeyWords,
			s.fixedId, s.HasWJTasting, s.IsActiveWineN, s.Issue, s.IsERPTasting, s.IsWJTasting, s.IsCurrentlyForSale,
			s.LabelName, s.Location, s.Locale, s.Maturity, s.MostRecentPrice, s.MostRecentPriceHi, s.MostRecentAuctionPrice,
			s.Notes,
			s.Producer, s.ProducerShow, s.ProducerURL, s.ProducerProfileFileName, s.ShortTitle, s.Publication, s.Places,
			s.Region, s.Rating, s.RatingShow, s.ReviewerIdN, s.showForERP, s.showForWJ, s.source, s.SourceDate, s.Site,
			s.Vintage, s.Variety, s.VinN, s.WineN, s.WineType,
			s.oldIdn, s.oldWineN, s.oldVinN, s.RV_TasteNote, s.RV_Wine_N)
	OUTPUT $action, inserted.ID INTO @Res;

	declare @ins int, @upd int
	select @ins = count(*) from @Res where Act = 'INSERT'
	select @upd = count(*) from @Res where Act = 'UPDATE'
	
	print '-- Inserted: ' + cast(@ins as varchar(20)) + '; Updated: ' + cast(@upd as varchar(20))
			
end
begin try
	alter fullText Index on Wine enable;
end try
begin catch
end catch

RETURN 1