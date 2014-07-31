CREATE FUNCTION [dbo].[KeywordsToSQLWhereQ2]
(@keywords NVARCHAR (MAX))
RETURNS NVARCHAR (MAX)
AS
 EXTERNAL NAME [smartKeywordsClass2].[SmartKeywordsClass2].[KeywordsToSQLWhereQ]

