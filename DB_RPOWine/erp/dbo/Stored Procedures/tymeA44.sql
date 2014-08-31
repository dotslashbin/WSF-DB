create proc tymeA44(@parm nvarchar(999), @r int output)
as begin
declare @sql nvarchar(max) =';with a as (select top 300 * from [EROBPARK-4\EROBPARK2K8].erpsearch3.dbo.wine where contains( encodedKeywords, @parm)     )
select @r = sum(isnull(len(notes),0)) from a'
exec sp_executeSQL @sql, N'@parm nvarchar(999), @r int OUTPUT',  @parm, @r=@r OUTPUT
end
