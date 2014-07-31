-- example function for larisa to rewrite in JScript for the row by row individualized my wines popup [=]

/*
Notation for replacement strings at the end
	<BR>	break
	<IN>	indent at beginning of a line (maybe 5 non-breaking spaces - or whatever looks right in the particular display (HTML, Silverlight menu))
	<ED>	Edit the corresponding value.  Uses the actual action defined earlier on the line, but shows the word "Edit" in a distintive font (maybe small and italic)
*/
CREATE function myPopup (@bottleCount int, @wantToBuyCount int, @sellerCount int, @wantToSellCount int, @buyerCount int, @tastingCount int, @isOfInterest  bit)
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
		Set @s = @s + '<a1>Just mark "of interest"</a><BR>'
		End
	Else begin
		Set @s = @s + '"Of interest"<BI><a2>Change to "Not of interest"</a><BR>'
		end
	End
 
If @bottleCount = 0 begin
	Set @s = @s + '<a3>Add bottles to my cellar</a>'
 
	If @wantToBuyCount = 0 begin
		Set @s = @s + '<BR><a8>Buy this wine'
		End
	else begin
		Set @s = @s + '<BR><a8>You''re trying to buy ' + convert(varchar, @wantToBuyCount)
			+ ' bottle' + case when @wantToBuyCount > 1 then 's' else '' end + '<ED></a>'
		end
	End
Else begin
	Set @s = @s + '<a7>You have ' + convert(varchar, @bottleCount) + ' bottle' 
		+ case when @bottleCount > 1 then 's' else '' end + '<ED></a>'
	Set @s = @s + '<BI><a3>Add more</a>'
	Set @s = @s +'<BI><a4>Remove ' + case when @bottleCount =1 then 'it' else 'some' end + '</a>'
	
	if @wantToBuyCount = 0 and @wantToSellCount = 0 begin
		--set @s = @s + '<BI>---'
	
		if @wantToBuyCount = 0 begin
			set @s = @s + '<BI><a8>Buy more</a>'
			end
			
		If @wantToSellCount = 0 begin
			Set @s = @s + '<BI><a5>Sell ' + case when @bottleCount =1 then 'it' else 'some' end + '</a>'
			End
		end
	Else begin
		if @wantToBuyCount > 0 begin
			Set @s = @s + '<BR><a8>Trying to buy ' + convert(varchar, @wantToBuyCount)
				+ case when @bottleCount > 0 then ' more' else '' end + '<ED></a><SL>'
			end
 
		if @wantToSellCount > 0 begin
			Set @s = @s + '<BR><a6>Trying to sell ' + convert(varchar, @wantToSellCount)
				+ ' bottle' + case when @wantToSellCount > 1 then 's' else '' end + '<ED></a>'
				
			If @buyerCount > 0 begin
				Set @s = @s + '<BI><a11> (' + convert(varchar, @buyerCount) + ' buyer' + case when @buyerCount > 1 then 's' else '' end + ')</a>'
				end
			end
		End
 
	end
 
if @sellerCount > 0 begin
	set @s = replace(@s, '<SL>', '<BI><a12> (' + convert(varchar, @sellerCount) + ' seller' + case when @sellerCount >1 then 's' else '' end + ')</a>')
	end
else begin
	set @s = replace(@s, '<SL>', '')
	end
 
If @tastingCount = 0 begin
	Set @s = @s + '<BR><a9>Add a tasting note</a>'
	End
Else begin
	set @s = @s + '<BR><a10>You have ' + convert(varchar, @tastingCount )
		+ ' tasting note' + case when @tastingCount > 1 then 's' else '' end +'<ED></a>'
		+ '<BI><a9>Add another</a>'
	end
 
set @s = replace(@s, '<BI>', '<BR><IN>')


/*
if 1=1 begin 


--set @s = replace(@s, '<ED>', '<i><small> (edit)</small></i>')
set @s = replace(@s, '<ED>', ' (edit)')
 
set @s = replace(@s, '<IN>', '     ')
set @s = replace(@s, '<BR>', char(13) + char(10))
set @s = replace(@s, '</A>', '')
 
	set @s = replace(@s,'<a1>','')
	set @s = replace(@s,'<a2>','')
	set @s = replace(@s,'<a3>','')
	set @s = replace(@s,'<a4>','')
	set @s = replace(@s,'<a5>','')
	set @s = replace(@s,'<a6>','')
	set @s = replace(@s,'<a7>','')
	set @s = replace(@s, '<a8>','')
	set @s = replace(@s, '<a9>','')
	set @s = replace(@s, '<a10>','')
	set @s = replace(@s, '<a11>','')
	set @s = replace(@s, '<a12>','')
	set @s = replace(@s, '<a13>','')
	
	set @s = replace(@s, '</a>','')

end
*/
 
 
return @s
end
/*

<a7>You have 1 bottle (edit)</a>
     <a3>Add more</a>
     <a4>Remove it</a>
<a8>Want to buy 2 more</a>
     <a12> (3 sellers)</a>
<a6>Want to sell 4 bottles</a>
     <a11> (5 buyers)</a>
<a10>You have 6 tasting notes</a>
     <a9>Add another</a>




print dbo.myPopup(0,0,0,0,0,0,0)
print dbo.myPopup(0,0,0,0,0,0,1)
 
--currently not displaying well:
print dbo.myPopup(1,2,3,1,0,0,1)
print dbo.myPopup(1,2,3,4,5,6,1)
print dbo.myPopup(0,2,3,4,5,6,1)
print dbo.myPopup(0,0,3,4,5,6,1)
 
*/
 
 
 
