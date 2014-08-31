CREATE function updateTranslateToTasterN(@tasterName varchar(max))
returns int
as begin
	declare @whN int
	select @whN=whN from erp..wh where fullName = @tasterName
	if @whN is null
		select @whN=whN from erp..wh where fullName = dbo.superTrim(@tasterName)
	return @whN	
end
 
