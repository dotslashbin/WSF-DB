-- example function for larisa to rewrite in JScript for the row by row individualized my wines popup [=]

/*
Notation for replacement strings at the end
	<BR>	break
	<SP> non-breaking space
	<IN>	indent at beginning of a line (maybe 5 spaces - or whatever looks right in the particular display (HTML, Silverlight menu))
	<BI> line break followed by indent of 5 spaces (or whatever looks right in the particular display (HTML, Silverlight menu)
	<ED>	Edit the corresponding value.  Uses the actual action defined earlier on the line, but shows the word "Edit" in a distintive font (maybe small and italic)

*/
create function myPopup_old (@bottleCount int, @wantToBuyCount int, @sellerCount int, @wantToSellCount int, @buyerCount int, @tastingCount int, @isOfInterest  bit)
returns varchar(3000)
as begin
 
select
	 @bottleCount = isNull(@bottleCount,0)
	,@tastingCount = isNull(@tastingCount,0)
	,@wantToBuyCount = isNull(@wantToBuyCount,0)
	,@wantToSellCount = isNull(@wantToSellCount,0)
	,@sellerCount = isNull(@sellerCount,0)
	,@isOfInterest = isNull(@isOfInterest,0)
 
declare @s varchar(3000); set @s = ''
 
 
--If @bottleCount = 0 and @tastingCount = 0 and @wantToSellCount = 0 and @wantToBuyCount = 0 begin
If @bottleCount = 0 and @tastingCount = 0 and @wantToBuyCount = 0 begin
	If @isOfInterest = 0 begin
		Set @s = @s + '<<1>>Just mark "of interest"</a><BR>'
		End
	Else begin
		Set @s = @s + '"Of interest"<BI><<2>>Change to "Not of interest"</a><BR>'
		end
	End
 
If @bottleCount = 0 begin
	Set @s = @s + '<<3>>Add bottles to my cellar</a>'
 
	If @wantToBuyCount = 0 begin
		Set @s = @s + '<BR><<8>>Buy this wine'
		End
	else begin
		Set @s = @s + '<<8>><BR>Trying to buy ' + convert(varchar, @wantToBuyCount)
			+ ' bottle' + case when @wantToBuyCount > 1 then 's' else '' end + '<SL></a>'
		end
	End
Else begin
	Set @s = @s + '<<7>>You have ' + convert(varchar, @bottleCount) + ' bottle' 
		+ case when @bottleCount > 1 then 's' else '' end + '</a>'
	Set @s = @s + '<BI><<3>>Add more</a>'
	Set @s = @s +'<BI><<4>>Remove ' + case when @bottleCount =1 then 'it' else 'some' end + '</a>'
	
	if @wantToBuyCount = 0 and @wantToSellCount = 0 begin
		--set @s = @s + '<BI>---'
	
		if @wantToBuyCount = 0 begin
			set @s = @s + '<BI><<8>>Buy more</a>'
			end
			
		If @wantToSellCount = 0 begin
			Set @s = @s + '<BI><<5>>Sell ' + case when @bottleCount =1 then 'it' else 'some' end + '</a>'
			End
		end
	Else begin
		if @wantToBuyCount > 0 begin
			Set @s = @s + '<BI><<8>>Buying ' + convert(varchar, @wantToBuyCount)
				+ case when @bottleCount > 0 then ' more' else '' end + '</a><SL>'
			end
 
		if @wantToSellCount > 0 begin
			Set @s = @s + '<BR><<6>>Selling ' + convert(varchar, @wantToSellCount)
				+ ' bottle' + case when @wantToSellCount > 1 then 's' else '' end + '</a>'
				
			If @buyerCount > 0 begin
				Set @s = @s + '<<11>> (' + convert(varchar, @buyerCount) + ' buyer' + case when @buyerCount > 1 then 's' else '' end + ')</a>'
				end
			end
		End
 
	end
 
if @sellerCount > 0 begin
	set @s = replace(@s, '<SL>', ' <<12>> (' + convert(varchar, @sellerCount) + ' seller' + case when @sellerCount >1 then 's' else '' end + ')</a>')
	end
else begin
	set @s = replace(@s, '<SL>', '')
	end
 
If @tastingCount = 0 begin
	Set @s = @s + '<BR><<9>>Add a tasting note</a>'
	End
Else begin
	set @s = @s + '<BR><<10>>You have ' + convert(varchar, @tastingCount )
		+ ' tasting note' + case when @tastingCount > 1 then 's' else '' end +'</a>'
		+ '<BI><<9>>Add another</a>'
	end
 
set @s = replace(@s, '<SP>', '  ')
 
--set @s = replace(@s, '<ED>', '<i><small></small></i>')
set @s = replace(@s, '<ED>', 'Edit')
 
set @s = replace(@s, '<BI>', '<BR><IN>')
set @s = replace(@s, '<IN>', '     ')
set @s = replace(@s, '<BR>', char(13) + char(10))
--set @s = replace(@s, '</A>', '')
 
--/*
set @s = replace(@s, '<1>','')
set @s = replace(@s, '<2>','')
set @s = replace(@s, '<3>','')
set @s = replace(@s, '<4>','')
set @s = replace(@s, '<5>','')
set @s = replace(@s, '<6>','')
set @s = replace(@s, '<7>','')
set @s = replace(@s, '<8>','')
set @s = replace(@s, '<9>','')
set @s = replace(@s, '<10>','')
set @s = replace(@s, '<11>','')
set @s = replace(@s, '<12>','')
set @s = replace(@s, '<13>','')
--*/
 
 
return @s
end
/*
print dbo.myPopup(0,0,0,0,0,0,0)
print dbo.myPopup(0,0,0,0,0,0,1)
 
--currently not displaying well:
print dbo.myPopup(1,2,3,1,0,0,1)	--not displaying well
 
*/
 
 
 
