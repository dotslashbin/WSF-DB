CREATE proc buildFakeLocations3(@whN int, @parent int, @prefix varchar(max), @maxWidth int, @maxDepth int)
as begin
	set noCount on
	declare @i int = 0, @locationN int, @prefix2 varChar(max), @maxDepth2 int
	if @maxDepth > 0
	begin
		set @locationN = @parent
		while(1=1)
		begin
			if @i >= @maxWidth break
			
			set @prefix2 = @prefix + char(97+ @i)
 
 
			insert into location(isBottle, whN, parentLocationN, prevItemIndex, name) select 0, @whN, @parent, @locationN, @prefix2
			set @locationN = scope_identity()
			set @maxDepth2 = @maxDepth - 1
			exec dbo.buildFakeLocations3 @whN, @locationN, @prefix2, @maxWidth, @maxDepth2
			
			set @i += 1
		end
	end
	set noCount off
end
/*
ooi ' location ', ''
*/