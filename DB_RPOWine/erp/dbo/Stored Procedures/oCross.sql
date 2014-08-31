create proc [dbo].[oCross] (@ta varChar(max), @tb varChar(max), @ignoreWords varChar(max) = '')
as begin
	select * from oCrossT(@ta, @tb, @ignoreWords)
end
