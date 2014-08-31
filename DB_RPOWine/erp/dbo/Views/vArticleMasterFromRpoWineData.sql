-- article database master update [=]
CREATE view [dbo].[vArticleMasterFromRpoWineData] 

as

select dbo.getPubN(publication) pubN,sourceDate pubDate,issue,shortTitle,
	--pages,
	dbo.getTasterN(source) tasterN,
	articleId,clumpName,articleIdnKey _x_articleIdnKey
from 
	(select 
		publication,sourceDate,issue,shortTitle,
		--pages,
		source,articleId,clumpName,articleIdnKey
	from dbo.SYN_t_Wine	-- rpowineDatad..wine
	group by publication,sourceDate,issue,shortTitle,
		--pages,
		source,articleId,clumpName,articleIdnKey
	) a
