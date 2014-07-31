CREATE proc [dbo].[importMsgInfo](@whN int)
as begin
--declare @whN int = 20
declare @sql nvarchar(max)
set @sql = N'
update transfer..importStatus 
	set
		  [matched] = (select count(*) from transfer..userwines@@ where 1 = isNumeric(wineN) and 0=isNull(isdetail,0))
		  , autoMatched =0
		, noMatchPossible = (select count(*) from transfer..userwines@@ where 1 = noMatch and 0=isNull(isdetail,0))
		, failedAutoVintage = 0
		, waitingToBeMatched = (select count(*) from transfer..userwines@@ where 0 = isNumeric(wineN) and 0=isNull(isdetail,0))
	where whN=@@;
	--delete from transfer..userwines@@ where 1 = isNumeric(wineN)'
set @sql = replace(@sql, '@@', @whN)
exec sp_executeSQL @sql
end
/*
exec dbo.importMsgInfoDev 20
select * from transfer..importstatus
*/
