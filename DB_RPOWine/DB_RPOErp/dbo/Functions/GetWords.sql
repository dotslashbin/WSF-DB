CREATE FUNCTION [dbo].[GetWords]
(@s NVARCHAR (3000))
RETURNS 
     TABLE (
        [w] NVARCHAR (3000) NULL)
AS
 EXTERNAL NAME [wineMaint1].[getWords].[GetWords]

