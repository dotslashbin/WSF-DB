CREATE FUNCTION [dbo].[GetStrings]
(@s NVARCHAR (3000))
RETURNS 
     TABLE (
        [w] NVARCHAR (3000) NULL)
AS
 EXTERNAL NAME [wineMaint1].[UserDefinedFunctions].[GetStrings]

