CREATE proc [dbo].[speed] as begin
set nocount on
declare @T table(a nvarchar(max))
declare @i int=0

while @i<100000
	begin
	insert into @T(a)select 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'
	set @i+=1
	end
print @i
end

/*
speed
*/
