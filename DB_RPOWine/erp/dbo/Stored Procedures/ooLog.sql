CREATE proc [dbo].ooLog(@msg nvarchar(max)='', @1 nvarchar(max)=null, @2 nvarchar(max)=null) 
as begin
 
--------------------------------------------------------------------------------------------
-- protect against ooLog trying to work in transactions
--------------------------------------------------------------------------------------------
begin try
	begin transaction
	
	if object_id('ooLogs') is null
		create table ooLogs(msg nvarchar(max), timeOf dateTime,[rowVersion] rowversion)
 
	if @msg not like '%[^ ]%'
		begin
			select msg,timeOf from ooLogs order by [rowversion] desc
		end
	else
		begin
			if @msg in ('zap')
				begin
					truncate table ooLogs
					set @msg = 'Truncate Log ('+@msg+')'
				end
			if @msg='-' set @msg='----------------------------------------------'
			if @msg='=' set @msg='=============================='
				
			--if @1 is not null set @msg=replace(@msg, '@1',@1)
			--if @2 is not null set @msg=replace(@msg, '@2',@2)
			set @msg=replace(@msg, '@1',isnull(@1,''))
			set @msg=replace(@msg, '@2',isnull(@2,''))
			insert into ooLogs(msg,timeOf) select isnull(@msg,'null'),getDate()
		end
	
	commit transaction
end try
begin catch 
	rollback transaction
	declare @s nvarchar(max)=ERROR_MESSAGE()+' (line '+convert(nvarchar, ERROR_LINE())+')'
	RAISERROR (N'myWines/ooLog: %s',16,1,@s)
end catch
 
end
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
