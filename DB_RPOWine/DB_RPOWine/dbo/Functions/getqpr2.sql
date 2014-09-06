







CREATE function [dbo].[getqpr2] (@wineN int)
returns float 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

--
-- could not find wine, but return QPR = 1, average wine
--


declare @country as nvarchar(255)
declare @region  as nvarchar(255)
declare @location as nvarchar(255)
declare @dryness as nvarchar(255)
declare @colorclass as nvarchar(255)
declare @rating as smallint
declare @id as int
declare @90 as varchar(100) 
declare @91 as varchar(100) 
declare @92 as varchar(100) 
declare @93 as varchar(100) 
declare @94 as varchar(100) 
declare @95 as varchar(100) 
declare @96 as varchar(100) 
declare @97 as varchar(100) 
declare @98 as varchar(100) 
declare @99 as varchar(100) 
declare @100 as varchar(100) 
declare @mostRecentPrice as money
declare @avergePrice as money


if exists( select * from Wine where WineN = @wineN ) 
  begin
     set @id = 0
  end
 else
  return  null  



select 
@MostRecentPrice = MostRecentPrice, 
@rating = rating, 
@country = country, 
@region = Region , 
@location = Location, 
@dryness = Dryness, 
@colorclass = ColorClass   from Wine where WineN = @wineN 




SET @id = 
        CASE 
            -- Check for employee
            WHEN @country = 'Argentina' or @country = 'Chile' 
                THEN 1
            WHEN @country = 'Australia' 
                THEN 2
            WHEN @country = 'Austria' 
                THEN 3
            WHEN @country = 'Australia' and @region = 'Alsace' 
                THEN 4
            WHEN @country = 'France' and @region = 'Bordeaux' and @dryness ='dry' and @colorclass='white' 
                THEN 5
                 WHEN @country = 'France' and @region = 'Bordeaux' and @dryness ='dry' and @colorclass='red' 
                THEN 6
            WHEN @country = 'France' and @region = 'Bordeaux' and @dryness ='sweet' 
                THEN 7
            WHEN @country = 'France' and @region = 'Burgundy' and @colorclass='red' and (@location='Beaune' or @location='Nuits St Georges' or @location='Cote de Nuits' or @location='Cote de Beaune')
                THEN 8
            WHEN @country = 'France' and @region = 'Burgundy' and @colorclass='white' and (@location='Beaune' or @location='Nuits St Georges' or @location='Cote de Nuits' or @location='Cote de Beaune')
                THEN 9
            WHEN @country = 'France' and @region = 'Champagne' 
                THEN 10
            WHEN @country = 'France' and @region = 'Loire Valley' 
                THEN 11
            WHEN @country = 'France' and @region = 'Languedoc Roussillon' 
                THEN 12
            WHEN @country = 'France' and @location = 'Northern Rhone' 
                THEN 13
            WHEN @country = 'France' and @location = 'Southern Rhone' 
                THEN 14
            WHEN @country = 'France' and @region = 'S W France' 
                THEN 15
            WHEN @country = 'France' and @region not in ( 'S W France','Rhone','Languedoc Roussillon','Loire Valley','Champagne','Burgundy','Bordeaux','Alsace') 
                THEN 16
            WHEN @country = 'Italy' and @region = 'Piedmont' 
                THEN 17
            WHEN @country = 'Italy' and @region = 'Tuscany' 
                THEN 18
            WHEN @country = 'Italy' and @region not in ('Tuscany','Piedmont') 
                THEN 19
            WHEN @country = 'Germany' 
                THEN 20
            WHEN @country = 'New Zealand' 
                THEN 21
            WHEN @country = 'Portugal' or @country = 'Spain' 
                THEN 22
            WHEN @country = 'USA' and @region = 'California' and @colorclass='red' 
                THEN 23
            WHEN @country = 'USA' and @region = 'California' and @colorclass='white' 
                THEN 24
            WHEN @country = 'USA' and @region <> 'California' 
                THEN 25
            else
                0
        END;


if @MostRecentPrice is null or @MostRecentPrice <= 0 or @rating < 90 or @id = 0 
  begin
     return null 
  end


if exists ( select * from prices where ID = @id)
  begin
    select @90 = r90,
    @91 = r91,
    @92 = r92,
    @93 = r93,
    @94 = r94,
    @94 = r94,
    @95 = r95,
    @96 = r96,
    @97 = r97,
    @98 = r98,
    @99 = r99,
    @100 = r100 from prices where @id = id
  end
else
  return null
  

SET @avergePrice  = 
        CASE 
            WHEN @rating  = '90' 
                THEN @90
            WHEN @rating  = '91' 
                THEN @91
            WHEN @rating  = '92' 
                THEN @92
            WHEN @rating  = '93' 
                THEN @93
            WHEN @rating  = '94' 
                THEN @94
            WHEN @rating  = '95' 
                THEN @95
            WHEN @rating  = '96' 
                THEN @96
            WHEN @rating  = '97' 
                THEN @97
            WHEN @rating  = '98' 
                THEN @98
            WHEN @rating  = '99' 
                THEN @99
            WHEN @rating  = '100' 
                THEN @100
         end       

  if @rating is null or @avergePrice is null or @avergePrice <= 0
      return 100.0   


  return (@mostRecentPrice / @avergePrice)


END