CREATE FUNCTION [dbo].[combinePlaces]
(@region NVARCHAR (MAX), @location NVARCHAR (MAX), @locale NVARCHAR (MAX), @site NVARCHAR (MAX))
RETURNS NVARCHAR (MAX)
AS
 EXTERNAL NAME [wineMaint1].[WineMaint1].[combinePlaces]

