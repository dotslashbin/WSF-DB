 
CREATE function [dbo].[commonLeading](@a varchar(max), @b varchar(max)) returns varchar(max)
as begin
	--declare @a varchar(max) = 'abc def', @b varchar(max) = 'abc deg'
 
	declare @i int = 1, @len int = len(@a), @r int = 0, @c char(1)
	if len(@a) > len(@b) 
		select @len +=1, @b += ' '
	else
		if len(@b) > @len
			select @len = len(@b) + 1, @a += ' '
	
	while	@i <=  @len
		begin
			set @c = subString(@a, @i, 1)
			if @c <> subString(@b, @i, 1) break
			if charIndex(@c, ' -.:') > 0 set @r = @i
			set @i += 1
		end
	if @i > @len
		return left(@a, @len+1)
	return left(@a, @r)          
end
/*
select dbo.commonLeading ('abc def', 'abc def dog')=>'abc def'
select dbo.commonLeading ('abc def', 'abc def')=>'abc def'
select dbo.commonLeading ('abc', 'abce')
select dbo.commonLeading ('ab-ce', 'ab-c')
select dbo.commonLeading ('ab.ce', 'ab.c')
select dbo.commonLeading ('ab:ce', 'ab:c')
 
select len(subString('aa', 3, 1))
 
*/
