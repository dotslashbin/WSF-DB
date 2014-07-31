create function tymeA33(@parm nvarchar(999)) returns int as begin
declare @r int
;with a as (select top 300 * from erpsearch3..Wine where contains( labelName, @parm)     )
select @r = sum(len(notes)) from a
return @r
end