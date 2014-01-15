
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

------------- Wines ----------
EXEC sp_fulltext_catalog @ftcat = 'RPOWine_FTSearchWine', @action = 'create'

CREATE FULLTEXT INDEX ON [dbo].[vWineDetails](
[Color] LANGUAGE [English], 
[Country] LANGUAGE [English], 
[Dryness] LANGUAGE [English], 
[Label] LANGUAGE [English], 
[Locale] LANGUAGE [English], 
[Location] LANGUAGE [English], 
[Producer] LANGUAGE [English], 
[Region] LANGUAGE [English], 
[Site] LANGUAGE [English], 
[Variety] LANGUAGE [English], 
[Vintage] LANGUAGE [English], 
[Type] LANGUAGE [English])
KEY INDEX [PK_vWineDetails]ON ([RPOWine_FTSearchWine], FILEGROUP [WineIndx])
WITH (CHANGE_TRACKING = AUTO, STOPLIST = OFF);

--------------------------------------------------------------------

RETURN 1

