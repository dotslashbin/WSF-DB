-- database utility [=]
CREATE FUNCTION [dbo].[getWhN] (	@Name varChar(200))
RETURNS int
AS
BEGIN
	Declare @R int, @n int
	select @n = count(*) from wh where displayName = @Name
	if 1 = @n
		set @R = (select top 1 whN from wh where displayName = @Name)
	else begin
			select @n = count(*) from wh where tag = @Name
			if 1 = @n
				set @R = (select top 1 whN from wh where tag = @Name)
			else 
				set @n = Null
	end
	RETURN @R
END
