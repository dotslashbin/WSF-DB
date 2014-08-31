CREATE FUNCTION [dbo].[getPubN]
(
	@PubName varChar(200)
)
RETURNS int
AS
BEGIN
	Declare @R int, @n int
	select @n = count(*) from wh where isPub = 1 and displayName = @PubName
	if 1 = @n
		set @R = (select top 1 whN from wh where isPub = 1 and displayName = @PubName)
	else begin
			select @n = count(*) from wh where isPub = 1 and tag = @PubName
			if 1 = @n
				set @R = (select top 1 whN from wh where isPub = 1 and tag = @PubName)
			else 
				set @n = Null
	end
	RETURN @R
END
