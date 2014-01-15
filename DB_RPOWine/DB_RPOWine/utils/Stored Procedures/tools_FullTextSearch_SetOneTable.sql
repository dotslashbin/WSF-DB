
CREATE PROCEDURE [utils].[tools_FullTextSearch_SetOneTable]
	@TableName nvarchar(256)
	
AS
set nocount on

EXEC sp_fulltext_table @TableName,'activate'
EXEC sp_fulltext_table @TableName,'start_full'
EXEC sp_fulltext_table @TableName, 'start_change_tracking'
EXEC sp_fulltext_table @TableName, 'start_background_updateindex'

RETURN 1

