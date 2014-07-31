/*
use erp

------------------------------------------------------------------------------------------------------------------------------
exec dbo.ddebug 'inserIntoWineName before', @wineNameN
------------------------------------------------------------------------------------------------------------------------------
*/
CREATE proc [dbo].[ddebug](@context nvarchar(max), @wineNameN int) as begin
declare @p1 nvarchar(max), @p2 nvarchar(max), @ss nvarchar(max)
select @p1=isnull(producer, 'not in winename') from wineName where winenamen=@winenameN
select @p2=isnull(producer, 'not in masterLocProducer') from masterLocProducer where producer=@p1

if @wineNamen is null set @wineNameN='no WineNameN' 
if @p1 is null set @p1='not in winename' 
if @p2 is null set @p2='not in masterLocProducer'		  

select @ss = @context +'     '+convert(nvarchar, @wineNameN) + '      ' + @p1+ '      ' + @p2
print @ss
end	  
