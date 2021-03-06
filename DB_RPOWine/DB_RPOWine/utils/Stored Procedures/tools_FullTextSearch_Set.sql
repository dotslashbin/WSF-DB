﻿
CREATE PROCEDURE [utils].[tools_FullTextSearch_Set]
--
---------- setting up a full-text search catalog -------------
--
-- Do not forget to set 'text in row' option for a tables with varchar(max)-like fields
--	exec sp_tableoption @TableNamePattern = '<TableName>', @OptionName = 'text in row', @OptionValue = '256' 
--

AS
set nocount on

declare @DBName varchar(30) = rtrim(db_name()),
		@FTCatalogName varchar(30)
		
EXEC sp_fulltext_database @action = 'enable' 

-- register an empty stop list
CREATE FULLTEXT STOPLIST [RPOWineDataStopList]
AUTHORIZATION [dbo];

------------- Wine ----------
	--CREATE FULLTEXT CATALOG [RPOWine_FTSearchWine]WITH ACCENT_SENSITIVITY = ON
	--AUTHORIZATION [dbo];

	--IF not EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[vWineDetails]') AND name = N'PK_vWineDetails') BEGIN
	--	CREATE UNIQUE CLUSTERED INDEX [PK_vWineDetails] ON [dbo].[vWineDetails] 
	--	(
	--		[Wine_N_ID] ASC
	--	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [WineIndx]
	--end

	--CREATE FULLTEXT INDEX ON [dbo].[vWineDetails](
	--[Keywords] LANGUAGE [English])
	--KEY INDEX [PK_vWineDetails]ON ([RPOWine_FTSearchWine], FILEGROUP [WineIndx])
	--WITH (CHANGE_TRACKING = AUTO, STOPLIST = OFF);
	
------------- Wine_Vin ----------
	CREATE FULLTEXT CATALOG [RPOWine_FTSearchVin]WITH ACCENT_SENSITIVITY = ON
	AUTHORIZATION [dbo];

	IF not EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[vWineVinNDetails]') AND name = N'PK_vWineVinNDetails') BEGIN
		CREATE UNIQUE CLUSTERED INDEX [PK_vWineVinNDetails] ON [dbo].[vWineVinNDetails] 
		(
			[Wine_VinN_ID] ASC
		)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [WineIndx]
	END

	CREATE FULLTEXT INDEX ON [dbo].[vWineVinNDetails](
	[Appellation] LANGUAGE [English], 
	[Color] LANGUAGE [English], 
	[Country] LANGUAGE [English], 
	[Dryness] LANGUAGE [English], 
	[Label] LANGUAGE [English], 
	[Locale] LANGUAGE [English], 
	[Location] LANGUAGE [English], 
	[Name] LANGUAGE [English], 
	[Producer] LANGUAGE [English], 
	[ProducerToShow] LANGUAGE [English], 
	[Region] LANGUAGE [English], 
	[Site] LANGUAGE [English], 
	[Type] LANGUAGE [English], 
	[Variety] LANGUAGE [English])
	KEY INDEX [PK_vWineVinNDetails]ON ([RPOWine_FTSearchVin], FILEGROUP [WineIndx])
	WITH (CHANGE_TRACKING = AUTO, STOPLIST = OFF);

------------- Wine - compatibility view ----------
	CREATE FULLTEXT CATALOG [RPOWine_WineOld]WITH ACCENT_SENSITIVITY = ON
	AUTHORIZATION [dbo];

	-- View version
	--IF not EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Wine]') AND name = N'PK_Wine') BEGIN
	--	CREATE UNIQUE CLUSTERED INDEX [PK_Wine] ON [dbo].[Wine] 
	--	(
	--		[TasteNote_ID] ASC
	--	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [WineIndx]
	--end

	--CREATE FULLTEXT INDEX ON [dbo].[Wine](
	----[BottleSize] LANGUAGE [English], 
	--[ColorClass] LANGUAGE [English], 
	----[CombinedLocation] LANGUAGE [English], 
	--[Country] LANGUAGE [English], 
	--[Dryness] LANGUAGE [English], 
	--[encodedKeyWords] LANGUAGE [English], 
	--[Issue] LANGUAGE [English], 
	--[LabelName] LANGUAGE [English], 
	--[Locale] LANGUAGE [English], 
	--[Location] LANGUAGE [English], 
	--[Notes] LANGUAGE [English], 
	--[Places] LANGUAGE [English], 
	--[Producer] LANGUAGE [English], 
	--[ProducerShow] LANGUAGE [English], 
	--[Publication] LANGUAGE [English], 
	--[RatingShow] LANGUAGE [English], 
	--[Region] LANGUAGE [English], 
	----[ShortLabelName] LANGUAGE [English], 
	--[Site] LANGUAGE [English], 
	--[Source] LANGUAGE [English], 
	--[Variety] LANGUAGE [English], 
	--[Vintage] LANGUAGE [English], 
	--[WineType] LANGUAGE [English])
	--KEY INDEX [PK_Wine]ON ([RPOWine_WineOld], FILEGROUP [WineIndx])
	--WITH (CHANGE_TRACKING = AUTO, STOPLIST = OFF);

	-- Table version
	CREATE FULLTEXT INDEX ON [dbo].[Wine](
	[ColorClass] LANGUAGE [English], 
	[Country] LANGUAGE [English], 
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
	[Site] LANGUAGE [English], 
	[source] LANGUAGE [English], 
	[Variety] LANGUAGE [English], 
	[Vintage] LANGUAGE [English], 
	[WineType] LANGUAGE [English])
	KEY INDEX [PK_Wine]ON ([RPOWine_WineOld], FILEGROUP [WineIndx])
	WITH (CHANGE_TRACKING = AUTO, STOPLIST = OFF);
	
---------------------------------

RETURN 1

