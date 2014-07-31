/*
print dbo.getWineNameVCL('Producer','cab','Rose','Cab bll', 'USA', null,null,null,null)
*/
CREATE function [dbo].getWineNameVCL (@producerShow nvarchar(100),@labelName nvarchar(150),@colorClass nvarchar(20),@variety nvarchar(100),@country nvarchar(100),@region nvarchar(100),@location nvarchar(100),@locale nvarchar(100),@site nvarchar(100))
returns varchar(max)
as begin
declare @s nvarchar(2000) = isNull(@producerShow,'')+isNull(' '+@labelName,'')
declare @sp nvarchar(500)='', @v nvarchar(500)
if @variety is not null
	begin
		if CHARINDEX(@variety,'blend')>0
			set @v=ltrim(rtrim(replace(@variety,' blend','')))
		else 
			set @v=@variety
		
		if CHARINDEX(@labelname,@v)=0
			set @sp=@variety+', '
	end
	
set @sp+=@colorClass+', '

if @locale is not null
	set @sp+=@locale
else
	begin
		if @site is not null
			set @sp+=@site
		else
			begin
				if @location is not null
					set @sp=@location
				else
					begin
						if @region is not null
							set @sp=@region
						else
							begin
								if @country is not null
									set @sp+=@country
								else
									set @sp+='no country'
							end
					end
			end	



	end	
return @s+' ('+@sp+')'
/*with a as (
		Select  (b.producerShow
			+isnull ( (' '+b.labelName) , '') 
			+isNull (' ('+isNull (colorClass+', ', '') 
			+isNull (isNull (b.site, isNull (b.locale, isNull (b.location, isNull (b.region, isNull (b.country, '') ) ) ) ) , '') +') ', '') ) fullWineNamePlus
	from 
		wine a
		join wineName b
			on b.wineNameN = a.wineNameN
		left join tasting e
			on e.wineN = a.wineN
				and (e.isPrivate <> 1  or e.tasterN = 20)
				and e.isActive=1
		left join whToWine h
			on h.wineN = a.wineN
				and h.whN = 20
	 where contains  (  a.encodedKeywords ,  '  "petrus*"   ' )    
)
  Select Top 100 fullWineNamePlus
	from a--Trace
*/
/*
declare @s nvarchar(max) =  dbo.wineSQL(
	'Select vintage, fullWineNamePlus, fullWineName'			--@Select2
	,100		--@maxRows,
	--,'where contains ( encodedKeywords, ''  "latour*"    and "1982"   '')  '				--@where
	,'where contains ( encodedKeywords, ''  "petrus*"   '')  '				--@where
	,''		--'Group by ratingRange'		--@GroupBy
	,''		--'Order by cnt desc'				--@OrderBy
	,9		--@PubGN
	,0--1		--@MustHaveReviewInThisPubG,
	,18220	--@PriceGN,
	,0		--@MustBeCurrentlyForSale,
	,0		--@IncludeAuctions,
	,20		--@whN,
	,1		 --@doFlagMyBottlesAndTastings,
	,0		--@doGetAllTastings
	,0		--@mustBeTrustedTaster
)
print @s
exec (@s)
 
 
 
 
*/
 
end
 
