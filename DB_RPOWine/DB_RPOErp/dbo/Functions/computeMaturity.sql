CREATE FUNCTION [dbo].[computeMaturity]
(@drinkFrom DATETIME, @drinkTo DATETIME, @tastingDate DATETIME)
RETURNS SMALLINT
AS
 EXTERNAL NAME [wineMaint1].[WineMaint1].[computeMaturity]

