-- database utility [=]
CREATE function [dbo].[getName2] 
	(@whN nvarchar(max)) 
returns varchar(max) 
as begin
	declare @s nvarchar(max) = ' [#' + convert(nvarchar, @whN) + ']'
	declare @s2 nvarchar(max) = (select fullName from wh where whN = @whN)
	if @s2 is not null
		set @s = @s2 + @s
 
	return isNull(@s, 'null')
end
 
 
 
