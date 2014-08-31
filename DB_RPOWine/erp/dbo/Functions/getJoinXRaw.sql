CREATE FUNCTION [dbo].[getJoinXRaw]
(
@Producer nvarchar(max), @labelName nvarchar(max), @colorClass nvarchar(max),  @country nvarchar(max),  @region nvarchar(max),  
@location nvarchar(max),  @locale nvarchar(max),  @site nvarchar(max),  @variety nvarchar(max), @wineType nvarchar(max),  @dryness nvarchar(max) 
 
)
RETURNS nvarchar(max)
AS
BEGIN
	Declare @R nvarchar(max)
	declare @n varchar(2000); set @n = ''
	declare @s varchar(2000); set @s = '|'
	set @R = 
		 (isNull(@Producer, @n)+@s+isNull(@labelName, @N)+@s+isNull(@colorClass, @N)+@s
		+isNull(@country, @N)	+@s+isNull(@region, @N)+@s+isNull(@location, @N) 	+@s+isNull(@locale, @N) +@s+ isNull(@site, @N)
		+@s+ isNull(@variety, @N) 	+@s+ isNull(@wineType, @N) +@s+isNull(@dryness, @N) )
 
 
	RETURN @R
 
END
 
