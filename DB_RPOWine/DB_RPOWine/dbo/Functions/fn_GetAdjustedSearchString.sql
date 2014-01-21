-- =============================================
-- Author: Alex B.
-- Create date: 1/18/2014
-- Description:	Adjusts a string using "macroses" defined in the KeywordMap_Wine
--				AND prepares it to be used in the full text search quesries (no spaces inside)
--				Used in Wine and WineVin search queries. 
--				Macroses are for the Label Name.
-- =============================================
CREATE FUNCTION fn_GetAdjustedSearchString
(
	@SearchString nvarchar(1024)
)
RETURNS nvarchar(1024)
AS
BEGIN

	-- ===== special keywords =====
	declare @newSearchString nvarchar(1024) = '',
		@sS nvarchar(120), @sD nvarchar(240)

	-- complex phrases
	if charindex(' ', @SearchString) > 0 begin
		declare crPh CURSOR forward_only fast_forward read_only for
			select Source, Destination 
			from KeywordMap_Wine km (nolock) 
			where charindex(' ', km.Source) > 0
				and @SearchString like '%' + km.Source + '%'
		open crPh
		fetch next from crPh into @sS, @sD
		while @@fetch_status = 0 begin
			if @sS is NOT NULL begin
				select @SearchString = replace(@SearchString, @sS, '')
				if len(@newSearchString) > 0
					select @newSearchString += ' AND ' 
				select @newSearchString += case when @sD is null then @sS else @sD end
			end
			fetch next from crPh into @sS, @sD
		end
		close crPh
		deallocate crPh
	end

	select @SearchString = rtrim(ltrim(@SearchString))

	-- single words
	if len(@SearchString) > 0 begin
		if isnull(charindex(' ', @SearchString), 0) < 1 begin
			if len(@newSearchString) > 0
				select @newSearchString += ' AND ' 
			select @sD = Destination from KeywordMap_Wine (nolock) where Source = @SearchString
			select @newSearchString += case when @sD is null then @SearchString else @sD end
		end else begin
			declare cr CURSOR forward_only fast_forward read_only for
				select Source = f.Item, Destination 
				from dbo.String2Table(@SearchString, ' ') f 
					left join KeywordMap_Wine km (nolock) on km.Source = replace(f.Item, '"' , '')
				where f.Item != '""'

			open cr
			fetch next from cr into @sS, @sD
			while @@fetch_status = 0 begin
				if @sS is NOT NULL begin
					if len(@newSearchString) > 0
						select @newSearchString += ' AND ' 
					select @newSearchString += case when @sD is null then @sS else @sD end
				end
				fetch next from cr into @sS, @sD
			end
			close cr
			deallocate cr
		end
	end
	-- ===== end of special keywords =====

	RETURN @newSearchString

END
GO
GRANT REFERENCES
    ON OBJECT::[dbo].[fn_GetAdjustedSearchString] TO [RP_DataAdmin]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fn_GetAdjustedSearchString] TO [RP_DataAdmin]
    AS [dbo];


GO
GRANT REFERENCES
    ON OBJECT::[dbo].[fn_GetAdjustedSearchString] TO [RP_Customer]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fn_GetAdjustedSearchString] TO [RP_Customer]
    AS [dbo];

