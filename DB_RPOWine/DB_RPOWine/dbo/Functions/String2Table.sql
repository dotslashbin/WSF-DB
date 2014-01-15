CREATE FUNCTION [dbo].[String2Table] 
(	
	@ItemsStr ntext					-- list of values to be parsed
	, @sepCharacter char(1) = ','	-- list separator character
)
--
-- Parses list of comma separated Items into @Items table
--

RETURNS @Items TABLE (Item nvarchar(50))
AS
begin
	declare 
			@ItemsList nvarchar(4000),
			@Item nvarchar(50), 
			@Pos int
	if datalength(@ItemsStr)<= 4000 --otherwise returns empty table
	begin
		select @ItemsList = LTRIM(RTRIM(cast(@ItemsStr as nvarchar(4000)))) + @sepCharacter
		select @Pos = CHARINDEX(@sepCharacter, @ItemsList, 1)
		if REPLACE(@ItemsList, @sepCharacter, '') <> '' begin
			while @Pos > 0 begin
				select @Item = LTRIM(RTRIM(LEFT(@ItemsList, @Pos - 1)))
				if @Item <> '' begin
					insert into @Items (Item) values (CAST(@Item AS nvarchar(50)))
				end
				select @ItemsList = RIGHT(@ItemsList, LEN(@ItemsList) + case when @sepCharacter = ' ' then 1 else 0 end - @Pos)
				select @Pos = CHARINDEX(@sepCharacter, @ItemsList, 1)
			end
		end	
	end
	return 
end


GO
GRANT SELECT
    ON OBJECT::[dbo].[String2Table] TO PUBLIC
    AS [dbo];

