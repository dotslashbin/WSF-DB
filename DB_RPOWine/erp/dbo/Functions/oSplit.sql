CREATE function oSplit(@s varchar(max), @divider varchar(max))
returns  @T table (part varchar(max))
as begin
	--declare @s varchar(max)='one   two', @divider varchar(max) = ' '
	--declare @T table(part varchar(max))
	declare @i int = 1, @j int = 0		 
 
	while 1=1
		begin
			select @j = charIndex(@divider, @s, @i)
			if @j = 0
				begin
					if @i < len(@s)
						insert into @T(part) select substring(@s, @i, len(@s)-@i+1)
					break
				end
				
			if @j-@i > 1
				insert into @T(part) select substring(@s, @i, @j-@i)
		
			set @i = @j+1
		end
 
		--select '[' + part + ']' from @T	
		
	return
end
 
