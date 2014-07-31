CREATE FUNCTION [dbo].[compactLocationSummary]
(@a NVARCHAR (MAX))
RETURNS NVARCHAR (MAX)
AS
 EXTERNAL NAME [myWinesClr].[locationSummaryClass].[compactLocationSummary]

