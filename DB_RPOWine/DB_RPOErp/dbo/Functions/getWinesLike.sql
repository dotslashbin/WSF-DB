CREATE function [dbo].[getWinesLike](@myWineName nvarchar(999))
returns @TT table(wineN int, vinn int, vintage nvarchar(5), matchName nvarchar(299), hasErpTasting bit)
as begin
 
--declare @keys nvarchar(999)=  dbo.KeywordsToSQLWhereQ(replace(@myWineName ,'''',''''''))        
--set @myWineName=replace(@myWineName,'"','')	--remove double qotes
declare @keys nvarchar(999)=  dbo.KeywordsToSQLWhereQ(@myWineName)
set @keys=substring(@keys,2,len(@keys)-2)
insert into @tt(winen, vinn, vintage,matchname,hasErpTasting)
	Select  a.wineN, a.activeVinn, a.vintage, matchName, hasErpTasting 
		from wine a
			join wineName b on b.wineNameN = a.wineNameN
		where contains  (  a.encodedKeywords , @keys);
 
return
end
 
 
		
