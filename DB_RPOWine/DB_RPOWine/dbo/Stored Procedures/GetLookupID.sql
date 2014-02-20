﻿-- =============================================
-- Author:		Alex B
-- Create date: 2/18/14
-- Description:	Gets internal ID of the lookup record.
--				It will automatically add new records into lookup tables, if necessary.
-- =============================================
CREATE PROCEDURE [dbo].[GetLookupID]
	@ObjectName as varchar(30), @ObjectValue as varchar(50)

AS
set nocount on

declare @Result int
set @ObjectValue = ltrim(rtrim(isnull(@ObjectValue, '')))

if (lower(@ObjectName) = 'userrole') begin
	select @Result = ID from UserRoles (nolock) where lower(Name) = lower(@ObjectValue)
	if isnull(@Result, 0) < 1 and len(isnull(@ObjectValue,'')) > 0 begin
		insert into UserRoles (Name) values (@ObjectValue)
		select @Result = scope_identity()
	end
end

if isnull(@Result, 0) < 1
	raiserror('Cannot find or create an entry in the [%s] with value [%s].', 16, 1, @ObjectName, @ObjectValue)

RETURN isnull(@Result, 0)
GO
GRANT EXECUTE
    ON OBJECT::[dbo].[GetLookupID] TO [RP_DataAdmin]
    AS [dbo];

