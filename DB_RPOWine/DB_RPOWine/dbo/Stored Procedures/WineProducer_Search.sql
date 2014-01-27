-- =============================================
-- Author:		Alex B
-- Create date: 1/26/2014
-- Description:	Returns list of WineProducer records containing @SearchString in the NameToShow.
--				Stored procedure requires input parameter @SearchString to be 
--				"as user types", no special characters (*, %, etc.) required and none 
--				of them will have special meaning.
-- =============================================
CREATE PROCEDURE [dbo].[WineProducer_Search]
	@SearchString nvarchar(1024), 
	@topNRows int = 100, -- @rankLimit int = 0,
	@LocationCountryID int = NULL, @LocationCountryName nvarchar(30) = NULL,
	@isDebug bit = 0

/*
exec WineProducer_Search @SearchString = 'Domaine du', @LocationCountryName = 'France', @topNRows = 30
*/

AS
set nocount on

select @SearchString = replace(replace(rtrim(ltrim(@SearchString)), '%', ''), '*', '')
if @SearchString is NULL or len(@SearchString) < 1 begin
	raiserror('Search String is required.', 16, 1)
	RETURN -1
end

if @LocationCountryID is NULL and @LocationCountryName is NOT NULL 
	exec @LocationCountryID = Location_GetLookupID @ObjectName='locCountry', @ObjectValue=@LocationCountryName, @IsAutoCreate=0

--select @SearchString = '%' + replace(@SearchString, ' ', '%') + '%'
select @SearchString = '%' + @SearchString + '%'
if @isDebug = 1
	print @SearchString	

select top(@topNRows)
	ID = wp.ID, 
	Name = wp.Name, 
	NameToShow = wp.NameToShow,
	SortOrder = case when wp.NameToShow like right(@SearchString, len(@SearchString)-1) then 0 else 20 end
from WineProducer wp (nolock)
where wp.NameToShow like @SearchString
	and (@LocationCountryID is NULL or wp.locCountryID = @LocationCountryID)
order by SortOrder, NameToShow, ID

RETURN 1
GO
GRANT EXECUTE
    ON OBJECT::[dbo].[WineProducer_Search] TO [RP_DataAdmin]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[WineProducer_Search] TO [RP_Customer]
    AS [dbo];

