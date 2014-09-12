

-- =============================================
-- Author:		Alex B
-- Create date: 1/22/14
-- Description:	Gets internal ID of the lookup record.
--				It will automatically add new records into lookup tables, if necessary AND @IsAutoCreate = 1.
-- =============================================
CREATE PROCEDURE [dbo].[Wine_GetLookupID]
	@ObjectName as varchar(30), @ObjectValue as nvarchar(120),
	@IsAutoCreate bit = 1

--
-- Gets ID of the lookup record if exists or creates a new entry and returns new ID.
-- Wine lookups are essentially cache tables, therefore "cache rules" - auto create - are applied by default.
--

AS
set nocount on

declare @Result int
set @ObjectValue = ltrim(rtrim(@ObjectValue))

--------------- simple 
if (lower(@ObjectName) = 'winebottlesize') begin
	select @Result = ID from WineBottleSize where lower(Name) = lower(@ObjectValue)
	if isnull(@Result, 0) < 1 and @IsAutoCreate = 1 and len(@ObjectValue) > 0 begin
		insert into WineBottleSize (Name) values (left(@ObjectValue, 30))
		select @Result = scope_identity()
	end
end

if (lower(@ObjectName) = 'winecolor') begin
	select @Result = ID from WineColor where lower(Name) = lower(@ObjectValue)
	if isnull(@Result, 0) < 1 and @IsAutoCreate = 1 and len(@ObjectValue) > 0 begin
		insert into WineColor (Name) values (left(@ObjectValue, 30))
		select @Result = scope_identity()
	end
end

if (lower(@ObjectName) = 'winedryness') begin
	select @Result = ID from WineDryness where lower(Name) = lower(@ObjectValue)
	if isnull(@Result, -1) < 0 and @IsAutoCreate = 1 and len(@ObjectValue) > 0 begin
		insert into WineDryness (Name) values (left(@ObjectValue, 30))
		select @Result = scope_identity()
	end
end

if (lower(@ObjectName) = 'winelabel') begin
	select @Result = ID from WineLabel where lower(Name) = lower(@ObjectValue)
	if isnull(@Result, -1) < 0 and @IsAutoCreate = 1 and len(@ObjectValue) > 0 begin
		insert into WineLabel (Name) values (left(@ObjectValue, 120))
		select @Result = scope_identity()
	end
end

if (lower(@ObjectName) = 'winetype') begin
	select @Result = ID from WineType where lower(Name) = lower(@ObjectValue)
	if isnull(@Result, 0) < 1 and @IsAutoCreate = 1 and len(@ObjectValue) > 0 begin
		insert into WineType (Name) values (left(@ObjectValue, 50))
		select @Result = scope_identity()
	end
end

if (lower(@ObjectName) = 'winevariety') begin
	select @Result = ID from WineVariety where lower(Name) = lower(@ObjectValue)
	if isnull(@Result, -1) < 0 and @IsAutoCreate = 1 and len(@ObjectValue) > 0 begin
		insert into WineVariety (Name) values (left(@ObjectValue, 50))
		select @Result = scope_identity()
	end
end

if (lower(@ObjectName) = 'winevintage') begin
	select @Result = ID from WineVintage where lower(Name) = lower(@ObjectValue)
	if isnull(@Result, 0) < 1 and @IsAutoCreate = 1 and len(@ObjectValue) > 0 begin
		insert into WineVintage (Name) values (left(@ObjectValue, 4))
		select @Result = scope_identity()
	end
end

------------- complex
if (lower(@ObjectName) = 'wineproducer') begin
	select @Result = ID from WineProducer where lower(Name) = lower(@ObjectValue)
	if isnull(@Result, 0) < 1
		select @Result = ID from WineProducer where lower(NameToShow) = lower(@ObjectValue)
	if isnull(@Result, 0) < 1 and @IsAutoCreate = 1 and len(@ObjectValue) > 0 begin
		insert into WineProducer (Name, NameToShow) values (left(@ObjectValue, 100), left(@ObjectValue, 100))
		select @Result = scope_identity()
	end
end

if ((lower(@ObjectName) in ('winelabel', 'winevariety','winedryness') and isnull(@Result, -1) < 0) 
	or (lower(@ObjectName) not in ('winelabel', 'winevariety','winedryness') and isnull(@Result, 0) < 1)) begin
	raiserror('Cannot find or create an entry in the [%s] with value "%s".', 16, 1, @ObjectName, @ObjectValue)
end

RETURN isnull(@Result, 0)
GO

GO

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[Wine_GetLookupID] TO [RP_DataAdmin]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[Wine_GetLookupID] TO [RP_Customer]
    AS [dbo];

