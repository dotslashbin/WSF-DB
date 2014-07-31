CREATE FUNCTION [dbo].[utilRegexMatch]
(@target NVARCHAR (MAX), @reg NVARCHAR (MAX), @regOptions INT)
RETURNS BIT
AS
 EXTERNAL NAME [wineMaint1].[WineMaint1].[utilRegexMatch]

