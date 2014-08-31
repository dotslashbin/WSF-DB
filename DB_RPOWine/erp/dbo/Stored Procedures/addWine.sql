CREATE proc [dbo].[addWine] (
	  @vintage varchar(4) 
	, @producer nvarchar(100)
	, @labelName nvarchar(150)
	, @colorClass nvarchar(20)
	, @variety nvarchar(100)
	, @dryness nvarchar(500)
	, @wineType nvarchar(500)
	, @country nvarchar(100)
	, @locale nvarchar(100)
	, @location nvarchar(100)
	, @region nvarchar(100)
	, @site nvarchar(100)
	, @comments nvarchar(max)
	, @namerWhN nvarchar(4)
	, @wineN int output
	)
as begin
	exec dbo.addWine2
		0, null, null
		 , @vintage
		, @producer
		, @labelName
		, @colorClass
		, @variety
		, @dryness
		, @wineType
		, @country
		, @locale
		, @location
		, @region
		, @site
		, @comments
		, @namerWhN
		, @wineN = @wineN output
end
 
/*
declare @wineN int;exec.dbo.addwine '1666','junkDoug','lablel2','red',null,null,null,null,null,null,null,null,null,20,@wineN=@wineN output

select top 3 * from winename order by rowversion desc

*/
