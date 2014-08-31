-- temporary function to group together fake publication entries xx [=]
CREATE function xxPubOrder (@a varchar(max)) returns int as begin

/*
/TT /TT1 2 3
/WC /WC1 2 3
/BB
/PZ
/FOB
*/


declare @x int, @scale int
select @x = 0, @scale = 100000000

select @scale = @scale / 10
if @a like '%/WC1%' set @x = @x + @scale * 4
else if @a like '%/WC2%' set @x = @x +@scale * 3
else if @a like '%/WC3%' set @x = @x + @scale * 2
else if @a like '%/WC%' set @x = @x + @scale

select @scale = @scale / 10
if @a like '%/PZ%' set @x = @x + @scale

select @scale = @scale / 10
if @a like '%/BB%' set @x = @x + @scale

select @scale = @scale / 10
if @a like '%/TT1%' set @x = @x + @scale * 4
else if @a like '%/TT2%' set @x = @x + @scale * 3
else if @a like '%/TT3%' set @x = @x + @scale * 2
else if @a like '%/TT%' set @x = @x + @scale 

select @scale = @scale / 10
if @a like '%/FOB%' set @x = @x + @scale

select @scale = @scale / 10
if @a like '%/%' set @x = @x + @scale


return @x

end

