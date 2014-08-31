create proc [dbo].[bug] as begin
declare @s nvarchar(max) =  dbo.wineSQL(
	--'Select taster, istrustedtaster, pubIconN, rating,ratingShow, ratingMinor, TastingN,wineN, vintage, fullWineName, colorClass, publication, forSaleIconN, priceLo, estimatedCostLo, priceShow, priceShowRelease, maturity,MyIconN,MyBottleCount,ProducerURL, Site , Locale,Location,Region ,Country, variety, dryness,  winetype,ProducerShow,hasUserComplaint'			--@Select2
	'Select taster, _FixedId, TastingN,wineN, vintage, producer, fullWineName, rating, colorClass, publication, Site , Locale,Location,Region ,Country, variety, dryness,  winetype'			--@Select2
	,100		--@maxRows,
	--Miani Merlot Filip
	--	,'where contains ( encodedKeywords, ''  "latour*"    and "1982"   '')  '				--@where
	,'where contains ( encodedKeywords, ''  "Miani*"    and "Merlot"    and "Filip"   '')  '				--@where
	,''		--'Group by ratingRange'		--@GroupBy
	,''		--'Order by cnt desc'				--@OrderBy
	,9		--@PubGN
	,0--1		--@MustHaveReviewInThisPubG,
	,18220	--@PriceGN,
	,0		--@MustBeCurrentlyForSale,
	,0		--@IncludeAuctions,
	,20		--@whN,
	,1		 --@doFlagMyBottlesAndTastings,
	,0		--@doGetAllTastings
	,0		--@mustBeTrustedTaster
)
print @s
exec (@s)
end
/*
taster				_FixedId	TastingN	wineN	vintage	producer	fullWineName	rating	colorClass	publication	Site	Locale	Location	Region	Country	variety	dryness	winetype
Antonio Galloni	236018	164795	162753	2007	Mazzei	Mazzei Serrata Belguardo	89	Red	Wine Advocate	NULL	NULL	NULL	Tuscany	Italy	Proprietary Blend	Dry	Table
 */
 
