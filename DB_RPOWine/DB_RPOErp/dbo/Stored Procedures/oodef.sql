/*dateUpdated: June 1 2010*/
CREATE proc [dbo].[oodef] @nm varChar(200), @isAlter bit=0 as begin
 /*
oodef oodef,1
*/ 
set noCount on
declare @s varchar(max), @loopCount int, @base int, @next int
select @s = definition from sys.default_constraints where [name] = @nm
if @s is null
	set @s = OBJECT_DEFINITION (OBJECT_ID('dbo.' + @nm))
    
if @isAlter=1
	begin
		declare @i int=charindex('create ', @s)
		set @s= substring(@s,1, @i-1) +'ALTER ' + substring(@s, @i+len('ALTER ')+2, len(@s))
	end

select @loopCount = 1000, @base = 1
while @loopCount > 0 begin
	set @next = charindex(char(13), @s, @base)
	if @next > 0 begin
		print substring(@s, @base, @next - @base)
		set @base = @next + 2
		end
	else begin
		print substring(@s, @base, 9999);
		break;
		end
 
	set @loopCount = @loopCount - 1
	end
END
 
