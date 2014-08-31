CREATE proc [dbo].[cursorExample]
as begin
 
declare @country varchar(max)
declare i cursor for select country from winename
open i
while 1=1
	begin
		fetch next from i into @country
		if @@fetch_status <> 0 break
		--xxxx
	end
close i
deallocate i
 end
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
