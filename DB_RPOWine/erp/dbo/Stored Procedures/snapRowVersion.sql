--database utility 		[=]
CREATE PROCEDURE [dbo].[snapRowVersion]
	@wh varchar(50) = null
	,@whFinish bit = 0
AS
BEGIN
	SET NOCOUNT ON;
	declare @whN int

	if isNumeric(@wh) = 1
		set @whN = cast(@wh as int)
	else 
		set @whN = dbo.erpDefaultUpdateId()
	
	if @whN is null set @whN = 0

	if not exists (select * from rowVersionHistory where xRowversion = @@DBTS and whN = 0 and whFinish = 0)
		insert into rowVersionHistory(xRowVersion, whN, whFinish, xDateTime) select @@DBTS, 0, 0, getDate()

	if @whN <> 0 or @whFinish <> 0 begin
		if not exists (select * from rowVersionHistory where xRowversion = @@DBTS and whN = @whN and whFinish = @whFinish)
			insert into rowVersionHistory(xRowVersion, whN, whFinish, xDateTime) select @@DBTS, @whN, @whFinish, getDate()
		else
			update rowVersionHistory set xDateTime = getDate() where xRowVersion = @@DBTS and whN = @whN and whFinish = @whFinish
		end

/*
exec snapRowVersion dwf, 1
select * from rowVersionHistory order by xRowVersion desc, xDateTime desc
*/



END

