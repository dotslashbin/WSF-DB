CREATE FUNCTION [dbo].[getJoinY]
(
@Producer nvarchar(max), @labelName nvarchar(max)
)
RETURNS nvarchar(max)
AS
BEGIN
	Declare @R nvarchar(max)
	declare @n varchar(2000); set @n = ''
	declare @s varchar(2000); set @s = '|'
	set @R = 
		 (isNull(@Producer, @n)+@s+isNull(@labelName, @N))
	RETURN @R
END
 
 
