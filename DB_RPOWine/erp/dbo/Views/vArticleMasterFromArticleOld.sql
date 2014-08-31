-- article database master update [=]
create view vArticleMasterFromArticleOld as
select dbo.getPubN(publication) pubN,sourceDate pubDate,issue,title,pages,dbo.getTasterN(source) tasterN,articleId,articleIdnKey _x_articleIdnKey
	from 
		(select publication,sourceDate,issue,title,pages,source,articleId,articleIdnKey
			from rpowineDatad..articles
			group by publication,sourceDate,issue,title,pages,source,articleId,articleIdnKey
			) a
