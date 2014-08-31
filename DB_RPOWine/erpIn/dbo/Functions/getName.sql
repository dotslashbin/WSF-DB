-- database utility [=]
CREATE function [dbo].[getName] 
	(@whN nvarchar(max)) 
returns varchar(max) 
as begin
	declare @s nvarchar(max) = @whN
	if isNumeric(@whN) = 1
		set @s = (select isNull(fullName, ' - ') from wh where whN = @whN)
	return @s
end
 
