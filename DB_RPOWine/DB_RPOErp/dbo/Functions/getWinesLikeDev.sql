CREATE function [dbo].[getWinesLikeDev] (@myWineName nvarchar(999))
returns @TT table(wineN int, vinn int, vintage nvarchar(5), matchName nvarchar(299),labelName nvarchar(299), hasErpTasting bit)
as begin
 
--declare @keys nvarchar(999)=  dbo.KeywordsToSQLWhereQ(replace(@myWineName ,'''',''''''))        
if (len(@myWineName)-len(replace(@myWineName,'"',''))) % 2 =1 
	set @myWineName = replace(@myWineName,'"',' ')	--blanks replace unbalanced double quotes
declare @keys nvarchar(999)=  dbo.KeywordsToSQLWhereQ(@myWineName)
set @keys=substring(@keys,2,len(@keys)-2)
insert into @tt(winen, vinn, vintage,matchname, labelName,hasErpTasting)
	Select  a.wineN, a.activeVinn, a.vintage, matchName,labelName, hasErpTasting 
		from wine a
			join wineName b on b.wineNameN = a.wineNameN
		where contains  (  a.encodedKeywords , @keys);
 
return
end
 
 
 
