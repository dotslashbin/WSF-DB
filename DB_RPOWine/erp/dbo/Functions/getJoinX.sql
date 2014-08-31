CREATE FUNCTION [dbo].[getJoinX]
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
		 (isNull(dbo.normalizeName(@Producer), @n)+@s+isNull(dbo.normalizeName(@labelName), @n)+@s+isNull(dbo.normalizeName(@colorClass), @n)+@s
		+isNull(dbo.normalizeName(@country), @n)	+@s+isNull(dbo.normalizeName(@region), @n)+@s+isNull(dbo.normalizeName(@location), @n) 	+@s+isNull(dbo.normalizeName(@locale), @n) +@s+ isNull(dbo.normalizeName(@site), @n)
		+@s+ isNull(dbo.normalizeName(@variety), @n) 	+@s+ isNull(dbo.normalizeName(@wineType), @n) +@s+isNull(dbo.normalizeName(@dryness), @n) )
 
 
	RETURN @R
 
END
 
