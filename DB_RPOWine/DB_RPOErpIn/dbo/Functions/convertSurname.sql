CREATE FUNCTION [dbo].[convertSurname]
(@s NVARCHAR (MAX))
RETURNS NVARCHAR (MAX)
AS
 EXTERNAL NAME [wineMaint1].[WineMaint1].[convertSurname]

