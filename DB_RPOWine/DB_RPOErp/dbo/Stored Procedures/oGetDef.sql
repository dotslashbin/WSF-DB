CREATE proc [dbo].[oGetDef](@name varchar(200), @db varchar(50)='', @def varchar(max) output)
as begin
--declare @name varchar(200)='addWine', @db varchar(50)='erp7'
if len(@db)>0 set @db+='.'
declare @q nvarchar(max) = 'select @def = definition from '+@db+'sys.default_constraints where [name] = '''+@name+'''
if @def is null
	select @def = definition from '+@db+'sys.sql_Modules where object_id=OBJECT_ID('''+@db+'dbo.'+@name+''')'
exec sp_executeSQL @q,N'@def varchar(max) output',@def=@def output
end
/*
declare @def varchar(max)
exec dbo.ogetDef 'addWine','erp7',@def=@def output
print @def
*/
