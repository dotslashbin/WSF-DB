CREATE proc [dbo].[addField]  @tableName nvarchar(300), @fieldName nvarchar(300)
as begin
		begin try
			exec ('alter table '+@tableName+' add '+@fieldName)
		end try
		begin catch end catch
end


