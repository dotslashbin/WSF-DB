-- =============================================
-- Author:		Alex B
-- Create date: 1/22/14
-- Description:	Gets internal ID of the lookup record.
--				It will automatically add new records into lookup tables, if necessary.
--				Used in Audit_Add stored procedure and not intended to be used anywhere else.
-- =============================================
CREATE PROCEDURE [dbo].[Audit_GetLookupID]
	@ObjectName as varchar(30), @ObjectValue as varchar(50)

AS
set nocount on

declare @Result int
set @ObjectValue = ltrim(rtrim(isnull(@ObjectValue, '')))

if (lower(@ObjectName) = 'entrytype') begin
	select @Result = ID from Audit_EntryTypes (nolock) where lower(Name) = lower(@ObjectValue)
	if isnull(@Result, 0) < 1 and len(isnull(@ObjectValue,'')) > 0 begin
		insert into Audit_EntryTypes (Name) values (@ObjectValue)
		select @Result = scope_identity()
	end
end

if (lower(@ObjectName) = 'entrycategory') begin
	select @Result = ID from Audit_EntryCategories (nolock) where lower(Name) = lower(@ObjectValue)
	if isnull(@Result, 0) < 1 and len(isnull(@ObjectValue,'')) > 0 begin
		insert into Audit_EntryCategories (Name) values (@ObjectValue)
		select @Result = scope_identity()
	end
end

if (lower(@ObjectName) = 'entrysource') begin
	select @Result = ID from Audit_EntrySources (nolock) where lower(Name) = lower(@ObjectValue)
	if isnull(@Result, 0) < 1 and len(isnull(@ObjectValue,'')) > 0 begin
		insert into Audit_EntrySources (Name) values (@ObjectValue)
		select @Result = scope_identity()
	end
end

if (lower(@ObjectName) = 'entryuser') begin
	select @Result = ID from Audit_EntryUsers (nolock) where lower(Name) = lower(@ObjectValue)
	if isnull(@Result, 0) < 1 and len(isnull(@ObjectValue,'')) > 0 begin
		insert into Audit_EntryUsers (Name) values (@ObjectValue)
		select @Result = scope_identity()
	end
end

if (lower(@ObjectName) = 'entrymachine') begin
	select @Result = ID from Audit_EntryMachines (nolock) where lower(Name) = lower(@ObjectValue)
	if isnull(@Result, 0) < 1 begin	-- and len(isnull(@ObjectValue,'')) > 0 begin
		insert into Audit_EntryMachines (Name) values (@ObjectValue)
		select @Result = scope_identity()
	end
end

if (lower(@ObjectName) = 'objecttype') begin
	select @Result = ID from Audit_ObjectTypes (nolock) where lower(Name) = lower(@ObjectValue)
	if isnull(@Result, 0) < 1 and len(isnull(@ObjectValue,'')) > 0 begin
		insert into Audit_ObjectTypes (Name) values (@ObjectValue)
		select @Result = scope_identity()
	end
end

if isnull(@Result, 0) < 1
	raiserror('Cannot find or create an entry in the [%s] with value [%s].', 16, 1, @ObjectName, @ObjectValue)

RETURN isnull(@Result, 0)
GO
GRANT EXECUTE
    ON OBJECT::[dbo].[Audit_GetLookupID] TO PUBLIC
    AS [dbo];

