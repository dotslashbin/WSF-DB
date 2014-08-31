CREATE proc [dbo].[updateMasterKeywords]
as begin
with
a as (select	  masterLocN
				, isNull(country + ' ','')
					+ isNull(region + ' ','')
					+ isNull(location + ' ','')
					+ isNull(sublocation + ' ','')
					+ isNull(detailedLocation,'')
				  as keyWords
		from masterLoc     )
update b
		set b.keywords = a.keywords
	from masterLoc b
		join a on b.masterLocN=a.masterLocN
	where b.keywords<>a.keywords 
			or (b.keywords is null and a.keywords is not null) 
			or (b.keywords is not null and a.keywords is null);
 
 
end
/*
updateMasterLoc
select * from masterLoc
 
oofr surname
*/
 
