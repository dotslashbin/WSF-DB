/*dateModified: June 1 2010*/
CREATE proc [dbo].[oGetDefAndDate](@name varchar(200), @db varchar(50)='', @def varchar(max) output, @modifyDate dateTime output)
as begin
--declare @name varchar(200)='addWine', @db varchar(50)='erp7'
if len(@db)>0 set @db+='.'
declare @q nvarchar(max) = 'select @def = definition from '+@db+'sys.default_constraints where [name] = '''+@name+'''
if @def is null
	select @def = definition from '+@db+'sys.sql_Modules where object_id=OBJECT_ID('''+@db+'dbo.'+@name+''')
select @modifyDate=modify_date from '+@db+'sys.objects where [name]='''+@name+''''
 
declare @tag varchar(20)='/*dateModified:'
declare @s varchar(max)='/*dateModified: June 1a 2010*/
alter proc oGetDefAndDate(@name varchar(200), @db varchar(50)='', @def varchar(max) output, @modifyDate dateTime output)'
declare @i int=charindex(@tag, @s)
if @i>0
	begin
		set @i+=len(@tag)
		declare @j int=charindex('*/', substring(@s,@i,len(@s)))
		if @j>0
			begin
				print subString(@s, @i, @j-1)
				begin try
				declare @m datetime=convert(datetime,subString(@s, @i, @j-1))
				end try begin catch end catch
				------------------------------------------------------------------------------------------------------------------------------
				-- Process datetime against one from sys.objects
				-- Write out new date in oDef
				------------------------------------------------------------------------------------------------------------------------------
				
				print @m
			end
	end
 
 
 
--print @q
exec sp_executeSQL @q,N'@def varchar(max) output,@modifyDate datetime output',@def=@def output, @modifyDate=@modifyDate output
end
 
