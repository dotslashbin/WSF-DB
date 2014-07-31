-- debug	test     xx          [=]
CREATE procedure wineSQLFields (@flds varchar(1000)) as begin
set noCount on

declare @sql varchar(5000); set @sql = ''



set @flds = ',' + replace(@flds, ' ','') + ','
set @flds = replace(@flds, ',,', ',')
set @sql = @flds

declare @a bit, @b bit, @c bit, @d bit, @e bit
select @a=1, @b=1, @c=1, @d=1, @e=1

if 0<>charIndex(',wineN,', @flds) begin set @sql = replace(@sql, ',wineN,',',a.wineN,'); set @a = 1 end
if 0<>charIndex(',vintage,', @flds) begin set @sql = replace(@sql, ',vintage,',',a.vintage,'); set @a = 1 end
if 0<>charIndex(',producer,', @flds) begin set @sql = replace(@sql, ',producer,',',a.producer,'); set @a = 1 end
if 0<>charIndex(',producerShow,', @flds) begin set @sql = replace(@sql, ',producerShow,',',a.producerShow,'); set @a = 1 end
if 0<>charIndex(',producerURL,', @flds) begin set @sql = replace(@sql, ',producerURL,',',a.producerURL,'); set @a = 1 end
if 0<>charIndex(',producerProfileFile,', @flds) begin set @sql = replace(@sql, ',producerProfileFile,',',a.producerProfileFile,'); set @a = 1 end
if 0<>charIndex(',labelName,', @flds) begin set @sql = replace(@sql, ',labelName,',',a.labelName,'); set @a = 1 end
if 0<>charIndex(',country,', @flds) begin set @sql = replace(@sql, ',country,',',a.country,'); set @a = 1 end
if 0<>charIndex(',region,', @flds) begin set @sql = replace(@sql, ',region,',',a.region,'); set @a = 1 end
if 0<>charIndex(',location,', @flds) begin set @sql = replace(@sql, ',location,',',a.location,'); set @a = 1 end
if 0<>charIndex(',fullName,', @flds) begin set @sql = replace(@sql, ',fullName,',',(a.producerShow+case when a.labelName is null then '''' else '' ''+a.labelName end)fullName,');	 set @a = 1 end

if 0<>charIndex(',locale,', @flds) begin set @sql = replace(@sql, ',locale,',',a.locale,'); set @a = 1 end
if 0<>charIndex(',site,', @flds) begin set @sql = replace(@sql, ',site,',',a.site,'); set @a = 1 end
if 0<>charIndex(',variety,', @flds) begin set @sql = replace(@sql, ',variety,',',a.variety,'); set @a = 1 end
if 0<>charIndex(',colorClass,', @flds) begin set @sql = replace(@sql, ',colorClass,',',a.colorClass,'); set @a = 1 end
if 0<>charIndex(',dryness,', @flds) begin set @sql = replace(@sql, ',dryness,',',a.dryness,'); set @a = 1 end
if 0<>charIndex(',wineType,', @flds) begin set @sql = replace(@sql, ',wineType,',',a.wineType,'); set @a = 1 end

if 0<>charIndex(',priceLo,', @flds) begin set @sql = replace(@sql, ',priceLo,',',(case when a.mostRecentPriceLo is null then a.estimatedCost end) priceLo,'); set @a = 1 end
if 0<>charIndex(',priceHi,', @flds) begin set @sql = replace(@sql, ',priceHi,',',(case when a.mostRecentpriceHi is null then a.estimatedCost end) priceHi,'); set @a = 1 end
if 0<>charIndex(',priceCnt,', @flds) begin set @sql = replace(@sql, ',priceCnt,',',(isNull(priceCnt,0)) priceCnt,'); set @a = 1 end
if 0<>charIndex(',tastingN,', @flds) begin set @sql = replace(@sql, ',tastingN,',',a.tastingN,'); set @a = 1 end
if 0<>charIndex(',pubIconN,', @flds) begin set @sql = replace(@sql, ',pubIconN,',',a.pubIconN,'); set @a = 1 end
if 0<>charIndex(',rating,', @flds) begin set @sql = replace(@sql, ',rating,',',a.rating,'); set @a = 1 end
if 0<>charIndex(',ratingHi,', @flds) begin set @sql = replace(@sql, ',ratingHi,',',a.ratingHi,'); set @a = 1 end

if 0<>charIndex(',ratingShow,', @flds) begin set @sql = replace(@sql, ',ratingShow,',',a.ratingShow,'); set @a = 1 end
if 0<>charIndex(',maturity,', @flds) begin set @sql = replace(@sql, ',maturity,',',isNull(a.maturity, 6),'); set @a = 1 end
if 0<>charIndex(',articleURL,', @flds) begin set @sql = replace(@sql, ',articleURL,',',a.articleURL,'); set @a = 1 end
if 0<>charIndex(',publication,', @flds) begin set @sql = replace(@sql, ',publication,',',a.publication,'); set @a = 1 end
if 0<>charIndex(',pubDate,', @flds) begin set @sql = replace(@sql, ',pubDate,',',a.pubDate,'); set @a = 1 end
if 0<>charIndex(',tasteDate,', @flds) begin set @sql = replace(@sql, ',tasteDate,',',a.tasteDate,'); set @a = 1 end
if 0<>charIndex(',issue,', @flds) begin set @sql = replace(@sql, ',issue,',',a.issue,'); set @a = 1 end
if 0<>charIndex(',pages,', @flds) begin set @sql = replace(@sql, ',pages,',',a.pages,'); set @a = 1 end
if 0<>charIndex(',notes,', @flds) begin set @sql = replace(@sql, ',notes,',',a.notes,'); set @a = 1 end
if 0<>charIndex(',clumpName,', @flds) begin set @sql = replace(@sql, ',clumpName,',',a.clumpName,'); set @a = 1 end
if 0<>charIndex(',articleIdNKey,', @flds) begin set @sql = replace(@sql, ',articleIdNKey,',',a.articleIdNKey,'); set @a = 1 end
if 0<>charIndex(',articleOrder,', @flds) begin set @sql = replace(@sql, ',articleOrder,',',a.articleOrder,'); set @a = 1 end
if 0<>charIndex(',tasterN,', @flds) begin set @sql = replace(@sql, ',tasterN,',',a.tasterN,'); set @a = 1 end
if 0<>charIndex(',taster,', @flds) begin set @sql = replace(@sql, ',taster,',',a.whN taster,'); set @a = 1 end



/*


 

 (will be replaced by a new mechanism to map articles=>tastings)
 (will be used in the new article table, but shouldn't be needed in wine lists)


wineN
vintage
producer
 producerShow
 producerURL
producerProfileFile
labelName
country
region
location
locale
site
variety
colorClass
dryness
wineType
priceLo
priceHi
priceCnt
tastingN 
pubIconN
rating
ratingShow
maturity
articleURL ("relative" URL on eRP site)
publication 
pubDate ("sourceDate" in the current system
tasteDate (algorithmically derived from the notes)
issue
taster ("source" in the current system
notes
-----------------------------
(other fields that I may want for work with my replacement of article table setup I discussed a few weeks ago)
pages
clumpName
articleIdNKey (will be replaced by a new mechanism to map articles=>tastings)
articleOrder (will be used in the new article table, but shouldn't be needed in wine lists)



*/
set @sql = replace(@sql, ',', ', ')
set @sql = replace(@sql, '(', ' (')
set @sql = replace(@sql, ')', ') ')
set @sql = replace(@sql, '  ', ' ')
print @sql

end
