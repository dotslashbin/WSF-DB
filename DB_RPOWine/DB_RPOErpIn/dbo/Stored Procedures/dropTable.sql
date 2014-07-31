CREATE proc dropTable (@name varchar(max)) as
begin
	begin try
	declare @s varchar(max) = 'drop table ' + @name
	exec (@s)
	end try begin catch end catch
end
