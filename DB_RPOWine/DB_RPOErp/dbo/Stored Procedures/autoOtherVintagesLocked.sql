CREATE proc [dbo].[autoOtherVintagesLocked](@whN int, @myWineName nvarchar(999), @wineN int=null) as begin
--declare @whN int=20, @myWineName nvarchar(999)='Clerc Milon'
-----------------------------------------------------------------------------------
-- Update Other Vintages
----------------------------------------------------------------------------------
 
declare @cntVinn int, @sq nvarchar(999), @matchName nvarchar(999)
 
if @wineN is null
	begin
		select @cntVinn= count(distinct b.activeVinn)
			from vuserwines a
				left join wine b on a.wineN=b.wineN
			where myWineName=@myWineName
				and isDetail=0
		 
		if @cntVinn=1
			begin
				select top 1 @wineN=a.wineN, @matchName=matchName
					from vuserwines a
						join wine b on a.wineN=b.wineN
						join wineName c on b.wineNameN=c.wineNameN
					where myWineName=@myWineName
						and isDetail=0
					 order by b.vintage desc
			end 
	end
 
if @wineN is not null
	begin	
		if @matchName is null
			begin
				select top 1 @matchName=matchName from vWinePlus where wineN=@wineN
			end
	
		set @sq = '
update transfer..userwines'+convert(nvarchar,@whN)+'
	set
	  erpWineName=@matchName
	, wineN=@wineN
	, presentBeforeThisCycle=1
	, fromSameVintage=0
	, fromOtherVintage=1
	, rowFlag= 4	--@flagGoodMatch
	, comments=''<b><small>(New  Vintage)</small></b>''     --, @commentsSelectedNew 
where myWineName=@myWineName and wineN is null and isDetail=0'
	exec sp_executeSQL @sq, N'@matchName nvarchar(999), @wineN int, @myWineName nvarchar(999)',@matchName, @wineN, @myWineName 
 
	end
end
 
 
