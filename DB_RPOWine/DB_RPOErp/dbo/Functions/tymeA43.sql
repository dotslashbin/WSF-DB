create function tymeA43(@parm nvarchar(999)) returns int as begin
declare @r int
;with a as (select top 300 * from [EROBPARK-4\EROBPARK2K8].erpsearch3.dbo.wine where contains( labelName, @parm)     )
select @r = sum(len(notes)) from a
return @r
end
