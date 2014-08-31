CREATE FUNCTION [dbo].[getEditorN]
(
	@Name varChar(200)
)
RETURNS int
AS
BEGIN
	Declare @R int, @s varchar(max)
	set @R = (select top 1 whN from wh where isEditor = 1 and displayName = @Name)
	if @R is null Begin
		if @name like 'doug%' set @s = 'dwf'
		if @name like 'julian%' set @s = 'jb'
		if @name like 'mark%' set @s = 'mlb'
		
		set @R = (select top 1 whN from wh where isEditor = 1 and shortName = @s)
	end	

	RETURN @R
END


