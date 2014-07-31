CREATE FUNCTION [dbo].[getTasterN]
(
	@TasterName varChar(200)
)
RETURNS int
AS
BEGIN
	Declare @R int
	set @R = (select top 1 whN from wh where isProfessionalTaster = 1 and displayName = @TasterName)
	RETURN @R
END
