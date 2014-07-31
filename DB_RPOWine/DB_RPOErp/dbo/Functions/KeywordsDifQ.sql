CREATE FUNCTION [dbo].[KeywordsDifQ]
(@keywords NVARCHAR (MAX), @matchName NVARCHAR (MAX), @LBold NVARCHAR (MAX), @RBold NVARCHAR (MAX))
RETURNS NVARCHAR (MAX)
AS
 EXTERNAL NAME [SmartKeywordsClass].[SmartKeywordsClass].[KeywordsDifQ]

