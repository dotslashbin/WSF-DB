
Create Procedure [findPub] (@s varchar(200))
as begin
	set noCount on
	set @s = dbo.normalizeForLike(@s)
	select whN, displayName, shortName, tag
		from wh where isPub = 1 
			and (displayName like @s or shortName like @s or tag like @s)
end

