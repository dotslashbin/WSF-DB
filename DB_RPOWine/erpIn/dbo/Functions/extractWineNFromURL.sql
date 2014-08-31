CREATE function extractWineNFromURL(@url varchar(max))
returns int
as begin
	--declare @url varchar(max) = 'http://www.erobertparker.com/newsearch/th.aspx?th=23780abc'
	declare @s varchar(max), @i int
	set @i = charIndex('th=', @url)
	set @s = subString(@url, @i+3,999)
	set @i = patIndex('%[^0-9]%', @s)
	if @i > 0 
		set @s = subString(@s, 1,@i-1)
	return convert(int, @s)
end
