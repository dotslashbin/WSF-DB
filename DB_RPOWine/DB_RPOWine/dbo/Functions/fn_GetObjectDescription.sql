-- =============================================
-- Author: Alex B.
-- Create date: 1/22/2014
-- Description:	Gets description of the record in JSON format.
--				Used to auto generate text in AuditLog functionality.
-- =============================================
CREATE FUNCTION [dbo].[fn_GetObjectDescription]
(
	@ObjectName as varchar(30), @ObjectID as int
)
RETURNS nvarchar(1024)
AS
BEGIN
	declare @msg nvarchar(1024)

	if (lower(@ObjectName) = 'wineproducer') begin
		select @msg = '{"WineProducer": {'
			+ '"id": ' + cast(ID as varchar(20)) 
			+ ', "name": "' + Name + '"'
			+ ', "nameToShow": "' + NameToShow + '"'
			+ ', "WebSiteURL": "' + isnull(WebSiteURL, '') + '"'
			+ '}}'
		from WineProducer (nolock)
		where ID = @ObjectID
	end else 
	if (lower(@ObjectName) = 'issue') begin
		select @msg = '{"Issue": {'
			+ '"id": ' + cast(i.ID as varchar(20)) 
			+ ', "PublicationName": "' + p.Name + '"'
			+ ', "Title": "' + i.Title + '"'
			+ ', "PublicationDate": "' + isnull(cast(i.PublicationDate as varchar(20)), '') + '"'
			+ '}}'
		from Issue i (nolock)
			join Publication p (nolock) on i.PublicationID = p.ID
		where i.ID = @ObjectID
	end
	
	RETURN @msg
END
GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fn_GetObjectDescription] TO [RP_DataAdmin]
    AS [dbo];

