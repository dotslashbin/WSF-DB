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
	end
	
	RETURN @msg
END
GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fn_GetObjectDescription] TO [RP_DataAdmin]
    AS [dbo];

