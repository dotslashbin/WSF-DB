-- =============================================
-- Author:		Alex B
-- Create date: 1/22/14
-- Description:	Adds new record to Audit Log.
-- =============================================
CREATE PROCEDURE [dbo].[Audit_Add]
	@ID int = NULL,
	@EntryDate datetime = NULL, @Type varchar(50), @Category varchar(50), 
	@Source varchar(50), @UserName varchar(50), @MachineName varchar(50), 
	@ObjectType varchar(50), @ObjectID varchar(80) = NULL,
	@Description varchar(256), @Message text = '',
	@ShowRes smallint = 1

AS
set nocount on
declare @Result int,
	@TypeID int, @CategoryID int, @SourceID int, @UserID int, @MachineID int, @ObjTypeID int

exec @TypeID = Audit_GetLookupID @ObjectName = 'entrytype', @ObjectValue = @Type
exec @CategoryID = Audit_GetLookupID @ObjectName = 'entrycategory', @ObjectValue = @Category
exec @SourceID = Audit_GetLookupID @ObjectName = 'entrysource', @ObjectValue = @Source
exec @UserID = Audit_GetLookupID @ObjectName = 'entryuser', @ObjectValue = @UserName
exec @MachineID = Audit_GetLookupID @ObjectName = 'entrymachine', @ObjectValue = @MachineName
exec @ObjTypeID = Audit_GetLookupID @ObjectName = 'objecttype', @ObjectValue = @ObjectType

if exists(select * from Audit_IDMapping (nolock) where ObjectTypeID = @ObjTypeID and OldObjectID = @ObjectID)
	select @ObjectID = NewObjectID from Audit_IDMapping (nolock) where ObjectTypeID = @ObjTypeID and OldObjectID = @ObjectID

insert into Audit ([EntryDate], [TypeID], [CategoryID], [SourceID], [UserNameID], [MachineNameID], 
	[ObjectTypeID], [ObjectID], [Description], [Message])
values (isnull(@EntryDate, getdate()), @TypeID, @CategoryID, @SourceID, @UserID, @MachineID, 
	@ObjTypeID, @ObjectID, @Description, @Message)
if @@error <> 0 begin
	select @Result = -1
end else begin
	select @Result = scope_identity()
end

if @ShowRes = 1 ---> always return new ID in the ADD procedure
	select Result = isnull(@Result, -1)

RETURN isnull(@Result, -1)
GO
GRANT EXECUTE
    ON OBJECT::[dbo].[Audit_Add] TO PUBLIC
    AS [dbo];

