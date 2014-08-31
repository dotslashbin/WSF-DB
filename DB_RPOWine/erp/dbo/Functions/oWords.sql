CREATE function [dbo].[oWords] (@combined varchar(max)     )
returns @TT table ( word varChar(max)     )
begin
 
--declare @combined varchar(max) = 'RParker Dave AGalloni'
--declare  @TT table ( word varChar(max)     )
 
declare @i int = 1, @j int = 2, @z int
declare @aLower int = ascii('a'), @zLower int = ascii('z'), @aUpper int = ascii('A'), @zUpper int = ascii('Z')
declare @s varchar(max) = ' ' + @combined + ' '
 
declare @this int = ascii(' '), @prior int
set @z = 2 + len(@combined)
while @j <= @z
	begin
		set @prior = @this
		set @this = ascii(substring(@s, @j, 1))
		if @prior between @aLower and @zLower
			begin
				if @this between @aUpper and @zUpper or @this not between @aLower and @zLower
					begin
						insert into @TT(word) select substring(@s, @i, @j-@i)
						set @i = @j
					end
			end
		else
			begin
				if @prior between @aUpper and @zUpper
					begin
						  /*if @this not between @aUpper and @zUpper and @this not between @aLower and @zLower
							begin
								insert into @TT(word) select substring(@s, @i, @j-@i)
								set @i = @j
							end      */
							if @this not between @aUpper and @zUpper
								begin
									if @this between @aLower and @zLower
										begin
											if (@j-@i) > 1insert into @TT(word) select substring(@s, @i, @j-@i)
										end
									else
										begin
											insert into @TT(word) select substring(@s, @i, @j-@i)
											set @i = @j
										end
								end
					end
				else
					begin
						set @i = @j
					end
			end
		
		set @j += 1
	end
--select * from @TT
return 
end
