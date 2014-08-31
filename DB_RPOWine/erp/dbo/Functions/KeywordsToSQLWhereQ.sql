CREATE FUNCTION [dbo].[KeywordsToSQLWhereQ]
(@keywords NVARCHAR (MAX))
RETURNS NVARCHAR (MAX)
AS
 EXTERNAL NAME [SmartKeywordsClass].[SmartKeywordsClass].[KeywordsToSQLWhereQ]

