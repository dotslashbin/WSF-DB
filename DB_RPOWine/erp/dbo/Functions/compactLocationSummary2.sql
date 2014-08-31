CREATE FUNCTION [dbo].[compactLocationSummary2]
(@a NVARCHAR (MAX))
RETURNS NVARCHAR (MAX)
AS
 EXTERNAL NAME [myWinesClr2].[locationSummaryClass2].[compactLocationSummary]

