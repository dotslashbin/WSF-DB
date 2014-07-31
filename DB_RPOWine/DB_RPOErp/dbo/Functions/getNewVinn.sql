CREATE function [dbo].[getNewVinn]()
returns int
as begin
declare @maxRealVinn int=1000000, @maxVinn int=2000000, @vinn int;

with
a as (	select min(activeVinn) a from wineName where activeVinn>@maxRealVinn     )
,b as (	select min(activeVinn) b from wine where activeVinn>@maxRealVinn     )
select @vinn = 
			case 
				when a is null then
					case 
						when b is null then
							@maxVinn
						else
							b
					end
				when b is null or a>b then
					a
				else
					b
			end
	from a,b
return @vinn-1
end
/*
use erpTiny
select dbo.getNewVinn()
select case when null is null or 5>null then 5 end
select case when 4 is null or null>4 then 5 end

declare @a int = null, @b int=3
select case when @a is null or @b>@a then @b else @a end
*/
