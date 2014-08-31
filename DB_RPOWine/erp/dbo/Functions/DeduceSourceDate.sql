CREATE FUNCTION [dbo].[DeduceSourceDate]
(@notes NVARCHAR (MAX))
RETURNS NVARCHAR (MAX)
AS
 EXTERNAL NAME [wineMaint1].[WineMaint1].[DeduceSourceDate]

