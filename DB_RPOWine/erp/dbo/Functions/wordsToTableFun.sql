--coding utility wip		[=]
CREATE  FUNCTION [dbo].[wordsToTableFun](@words varchar(max) = '')
RETURNS 
@TT table (word varchar(max))
AS
BEGIN

declare @T table (word varchar(max))


/*
Declare xcursor Cursor For Select SaleN, BuyerWhoN, WineN, BottleCount, TotalPrice from Sales order by saleDate
Declare @iTotalBottles int, @iSale int, @s varchar(999), @Description varChar(999), @count int
open xcursor
while true
		if @@fetch_status <> 0 break
		fetch next from xcursor into @SaleN, @BuyerWhoN, @wineN, @BottleCount, @TotalPrice
loop
*/

RETURN 
END
