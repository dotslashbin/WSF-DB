CREATE PROCEDURE [utils].[tools_FullTextSearch_Set]
--
---------- setting up a full-text search catalog -------------
--
-- Do not forget to set 'text in row' option for a tables with varchar(max)-like fields
--	exec sp_tableoption @TableNamePattern = '<TableName>', @OptionName = 'text in row', @OptionValue = '256' 
--

AS
set nocount on

EXEC sp_fulltext_database @action = 'enable' 

-- register an empty stop list
CREATE FULLTEXT STOPLIST [RPOWineSearchStopList]
AUTHORIZATION [dbo];

------------- FULLTEXT CATALOG ----------
	CREATE FULLTEXT CATALOG [RPOSearch_FTSearch]WITH ACCENT_SENSITIVITY = ON
	AUTHORIZATION [dbo];

------------- ForSaleDetail ----------
	CREATE FULLTEXT INDEX ON [dbo].[ForSaleDetail](
	[BottleSize] LANGUAGE [English], 
	[City] LANGUAGE [English], 
	[Country] LANGUAGE [English], 
	[Currency] LANGUAGE [English], 
	[Errors] LANGUAGE [English], 
	[RetailerCode] LANGUAGE [English], 
	[RetailerDescriptionOfWine] LANGUAGE [English], 
	[RetailerIdN] LANGUAGE [English], 
	[RetailerName] LANGUAGE [English], 
	[State] LANGUAGE [English], 
	[TaxNotes] LANGUAGE [English], 
	[URL] LANGUAGE [English], 
	[Vintage] LANGUAGE [English])
	KEY INDEX [PK_ForSaleDetail]ON ([RPOSearch_FTSearch], FILEGROUP [FTSearch])
	WITH (CHANGE_TRACKING = AUTO, STOPLIST = OFF);

------------- Wine ----------
	CREATE FULLTEXT INDEX ON [dbo].[Wine](
	[BottleSize] LANGUAGE [English], 
	[ColorClass] LANGUAGE [English], 
	[CombinedLocation] LANGUAGE [English], 
	[Country] LANGUAGE [English], 
	[DisabledFlag] LANGUAGE [English], 
	[Dryness] LANGUAGE [English], 
	[encodedKeyWords] LANGUAGE [English], 
	[Issue] LANGUAGE [English], 
	[LabelName] LANGUAGE [English], 
	[Locale] LANGUAGE [English], 
	[Location] LANGUAGE [English], 
	[Notes] LANGUAGE [English], 
	[Places] LANGUAGE [English], 
	[Producer] LANGUAGE [English], 
	[ProducerShow] LANGUAGE [English], 
	[Publication] LANGUAGE [English], 
	[RatingShow] LANGUAGE [English], 
	[Region] LANGUAGE [English], 
	[ShortLabelName] LANGUAGE [English], 
	[Site] LANGUAGE [English], 
	[Source] LANGUAGE [English], 
	[Variety] LANGUAGE [English], 
	[Vintage] LANGUAGE [English], 
	[WineType] LANGUAGE [English])
	KEY INDEX [PK_Wine]ON ([RPOSearch_FTSearch], FILEGROUP [FTSearch])
	WITH (CHANGE_TRACKING = AUTO, STOPLIST = OFF);
	
-------------- WineName --------------
	CREATE FULLTEXT INDEX ON [dbo].[WineName](
	[EncodedKeywords] LANGUAGE [English], 
	[LabelName] LANGUAGE [English], 
	[ProducerShow] LANGUAGE [English])
	KEY INDEX [PK_WineName] ON ([RPOSearch_FTSearch], FILEGROUP [FTSearch])
	WITH (CHANGE_TRACKING = AUTO, STOPLIST = OFF);
	
---------------------------------

RETURN 1
