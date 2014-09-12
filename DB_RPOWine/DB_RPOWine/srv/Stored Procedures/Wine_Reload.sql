-- =============================================
-- Author:		Alex B.
-- Create date: 4/19/2014
-- Description:	Completely reloads Wine table from vWine view
-- =============================================
CREATE PROCEDURE [srv].[Wine_Reload]
	@IsFullReload bit = 0
	
--
-- @IsFullReload = 1 --> truncates data in Wine table and completely reloads it.
-- @IsFullReload = 0 --> merges data
--

AS

set nocount on;
set xact_abort on;

if @IsFullReload = 1 begin
	truncate table Wine;

	begin try
		alter fullText Index on Wine disable;
	end try
	begin catch
	end catch

	insert into Wine (TasteNote_ID, Wine_N_ID, Wine_VinN_ID, IdN,
		ArticleID, ArticleIdNKey,
		ColorClass,	Country, ClumpName,	Dryness, DrinkDate, DrinkDate_hi, EstimatedCost, encodedKeyWords,
		fixedId, HasWJTasting, HasERPTasting, IsActiveWineN, Issue, IsERPTasting, IsWJTasting, IsCurrentlyForSale, IsCurrentlyOnAuction,
		LabelName, Location, Locale, Maturity, MostRecentPrice, MostRecentPriceHi, MostRecentAuctionPrice,
		Notes,
		Producer, ProducerShow, ProducerURL, ProducerProfileFileName, ShortTitle, Publication, Places,
		Region,	Rating, RatingShow, ReviewerIdN, showForERP, showForWJ, source, SourceDate, Site,
		Vintage, Variety, VinN, WineN, WineType,
		oldIdn, oldWineN, oldVinN, 
		
		wProducerID, wTypeID, wLabelID, wVarietyID, wDrynessID, wColorID, wVintageID,
		RV_TasteNote, RV_Wine_N
	)
	select TasteNote_ID, Wine_N_ID, Wine_VinN_ID, IdN,
		ArticleID, ArticleIdNKey,
		ColorClass,	Country, ClumpName,	Dryness, DrinkDate, DrinkDate_hi, EstimatedCost, encodedKeyWords,
		fixedId, HasWJTasting, HasERPTasting, isnull(IsActiveWineN, 0), Issue, IsERPTasting, IsWJTasting, IsCurrentlyForSale, IsCurrentlyOnAuction,
		LabelName, Location, Locale, Maturity, MostRecentPrice, MostRecentPriceHi, MostRecentAuctionPrice,
		Notes,
		Producer, ProducerShow, ProducerURL, ProducerProfileFileName, ShortTitle, Publication, Places,
		Region,	Rating, RatingShow, ReviewerIdN, showForERP, showForWJ, source, SourceDate, Site,
		Vintage, Variety, VinN, WineN, WineType,
		oldIdn, oldWineN, oldVinN, 
		
		wProducerID, wTypeID, wLabelID, wVarietyID, wDrynessID, wColorID, wVintageID,
		RV_TasteNote, RV_Wine_N
	from vWine;
	
	begin try
		alter fullText Index on Wine enable;
	end try
	begin catch
	end catch

end else begin

	declare @Res table(
		Act varchar(10),
		ID int null,
		DelID int null);

	select TasteNote_ID, Wine_N_ID, Wine_VinN_ID, IdN,
		ArticleID, ArticleIdNKey,
		ColorClass,	Country, ClumpName,	Dryness, DrinkDate, DrinkDate_hi, EstimatedCost, encodedKeyWords,
		fixedId, HasWJTasting, HasERPTasting, IsActiveWineN = isnull(IsActiveWineN,0), Issue, IsERPTasting, IsWJTasting, IsCurrentlyForSale, IsCurrentlyOnAuction,
		LabelName, Location, Locale, Maturity, MostRecentPrice, MostRecentPriceHi, MostRecentAuctionPrice,
		Notes,
		Producer, ProducerShow, ProducerURL, ProducerProfileFileName, ShortTitle, Publication, Places,
		Region,	Rating, RatingShow, ReviewerIdN, showForERP, showForWJ, source, SourceDate, Site,
		Vintage, Variety, VinN, WineN, WineType,
		oldIdn, oldWineN, oldVinN,
		wProducerID, wTypeID, wLabelID, wVarietyID, wDrynessID, wColorID, wVintageID,
		RV_TasteNote = cast(RV_TasteNote as binary(8)), 
		RV_Wine_N = cast(RV_Wine_N as binary(8))
	into #t
	from vWine;
	
	--CREATE NONCLUSTERED INDEX IX_t on #t (TasteNote_ID, Wine_N_ID, Wine_VinN_ID)
	alter table #t add constraint PR_t primary key (TasteNote_ID, Wine_N_ID);

	merge Wine as t
	using (
		select TasteNote_ID, Wine_N_ID, Wine_VinN_ID, IdN,
			ArticleID, ArticleIdNKey,
			ColorClass,	Country, ClumpName,	Dryness, DrinkDate, DrinkDate_hi, EstimatedCost, encodedKeyWords,
			fixedId, HasWJTasting, HasERPTasting, IsActiveWineN, Issue, IsERPTasting, IsWJTasting, IsCurrentlyForSale, IsCurrentlyOnAuction,
			LabelName, Location, Locale, Maturity, MostRecentPrice, MostRecentPriceHi, MostRecentAuctionPrice,
			Notes,
			Producer, ProducerShow, ProducerURL, ProducerProfileFileName, ShortTitle, Publication, Places,
			Region,	Rating, RatingShow, ReviewerIdN, showForERP, showForWJ, source, SourceDate, Site,
			Vintage, Variety, VinN, WineN, WineType,
			oldIdn, oldWineN, oldVinN, 
			wProducerID, wTypeID, wLabelID, wVarietyID, wDrynessID, wColorID, wVintageID,
			RV_TasteNote, RV_Wine_N
		from #t	--vWine
	) as s on t.TasteNote_ID = s.TasteNote_ID and t.Wine_N_ID = s.Wine_N_ID --and t.Wine_VinN_ID = s.Wine_VinN_ID
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
			HasERPTasting = isnull(s.HasERPTasting, t.HasERPTasting),
			IsActiveWineN = isnull(s.IsActiveWineN, t.IsActiveWineN), 
			Issue = isnull(s.Issue, t.Issue), 
			IsERPTasting = isnull(s.IsERPTasting, t.IsERPTasting), 
			IsWJTasting = isnull(s.IsWJTasting, t.IsWJTasting), 
			IsCurrentlyForSale = isnull(s.IsCurrentlyForSale, t.IsCurrentlyForSale),
			IsCurrentlyOnAuction = isnull(s.IsCurrentlyOnAuction, t.IsCurrentlyOnAuction),
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
			wProducerID = isnull(s.wProducerID, t.wProducerID), 
			wTypeID = isnull(s.wTypeID, t.wTypeID), 
			wLabelID = isnull(s.wLabelID, t.wLabelID), 
			wVarietyID = isnull(s.wVarietyID, t.wVarietyID), 
			wDrynessID = isnull(s.wDrynessID, t.wDrynessID), 
			wColorID = isnull(s.wColorID, t.wColorID), 
			wVintageID = isnull(s.wVintageID, t.wVintageID),
			RV_TasteNote = isnull(nullif(s.RV_TasteNote, 0x00), t.RV_TasteNote), 
			RV_Wine_N = isnull(nullif(s.RV_Wine_N, 0x00), t.RV_Wine_N)
	when not matched by target then
		INSERT (TasteNote_ID, Wine_N_ID, Wine_VinN_ID, IdN,
			ArticleID, ArticleIdNKey,
			ColorClass,	Country, ClumpName,	Dryness, DrinkDate, DrinkDate_hi, EstimatedCost, encodedKeyWords,
			fixedId, HasWJTasting, HasERPTasting, IsActiveWineN, Issue, IsERPTasting, IsWJTasting, IsCurrentlyForSale, IsCurrentlyOnAuction,
			LabelName, Location, Locale, Maturity, MostRecentPrice, MostRecentPriceHi, MostRecentAuctionPrice,
			Notes,
			Producer, ProducerShow, ProducerURL, ProducerProfileFileName, ShortTitle, Publication, Places,
			Region,	Rating, RatingShow, ReviewerIdN, showForERP, showForWJ, source, SourceDate, Site,
			Vintage, Variety, VinN, WineN, WineType,
			oldIdn, oldWineN, oldVinN, 
			wProducerID, wTypeID, wLabelID, wVarietyID, wDrynessID, wColorID, wVintageID,
			RV_TasteNote, RV_Wine_N
		)
		values(s.TasteNote_ID, s.Wine_N_ID, s.Wine_VinN_ID, IdN,
			s.ArticleID, s.ArticleIdNKey,
			s.ColorClass, s.Country, s.ClumpName, s.Dryness, s.DrinkDate, s.DrinkDate_hi, s.EstimatedCost, s.encodedKeyWords,
			s.fixedId, s.HasWJTasting, s.HasERPTasting, s.IsActiveWineN, s.Issue, s.IsERPTasting, s.IsWJTasting, s.IsCurrentlyForSale, s.IsCurrentlyOnAuction,
			s.LabelName, s.Location, s.Locale, s.Maturity, s.MostRecentPrice, s.MostRecentPriceHi, s.MostRecentAuctionPrice,
			s.Notes,
			s.Producer, s.ProducerShow, s.ProducerURL, s.ProducerProfileFileName, s.ShortTitle, s.Publication, s.Places,
			s.Region, s.Rating, s.RatingShow, s.ReviewerIdN, s.showForERP, s.showForWJ, s.source, s.SourceDate, s.Site,
			s.Vintage, s.Variety, s.VinN, s.WineN, s.WineType,
			s.oldIdn, s.oldWineN, s.oldVinN, 
			wProducerID, wTypeID, wLabelID, wVarietyID, wDrynessID, wColorID, wVintageID,
			s.RV_TasteNote, s.RV_Wine_N)
	when not matched by source then
		DELETE
	OUTPUT $action, inserted.ID, deleted.ID INTO @Res;

	drop table #t;
	
	declare @ins int, @upd int, @dlt int
	select @ins = count(*) from @Res where Act = 'INSERT'
	select @upd = count(*) from @Res where Act = 'UPDATE'
	select @dlt = count(*) from @Res where Act = 'DELETE'
	
	print '-- Inserted: ' + cast(@ins as varchar(20)) 
		+ '; Updated: ' + cast(@upd as varchar(20))
		+ '; Deleted: ' + cast(@dlt as varchar(20))
			
end

RETURN 1