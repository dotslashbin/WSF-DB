﻿-- =============================================
-- Author:		Alex B
-- Create date: 1/20/14
-- Description:	Gets internal ID of the lookup record.
--				It will automatically add new records into lookup tables, if necessary AND @IsAutoCreate = 1.
-- =============================================
CREATE PROCEDURE [dbo].[Location_GetLookupID]
	@ObjectName as varchar(30), @ObjectValue as nvarchar(150),
	@IsAutoCreate bit = 1

--
-- Gets ID of the lookup record if exists or creates a new entry and returns new ID.
-- Location lookups are essentially cache tables, therefore "cache rules" - auto create - are applied by default.
--

AS
set nocount on

declare @Result int
set @ObjectValue = ltrim(rtrim(@ObjectValue))

-- allow 0 values - each lookup table has an entry with ID = 0
if @ObjectValue is NULL or @ObjectValue = ''
	RETURN 0

if (lower(@ObjectName) = 'loccountry') begin
	select @Result = ID from LocationCountry where lower(Name) = lower(@ObjectValue)
	if isnull(@Result, 0) < 1 and @IsAutoCreate = 1 and len(@ObjectValue) > 0 begin
		insert into LocationCountry (Name) values (left(@ObjectValue, 25))
		select @Result = scope_identity()
	end
end

if (lower(@ObjectName) = 'loclocale') begin
	select @Result = ID from LocationLocale where lower(Name) = lower(@ObjectValue)
	if isnull(@Result, 0) < 1 and @IsAutoCreate = 1 and len(@ObjectValue) > 0 begin
		insert into LocationLocale (Name) values (left(@ObjectValue, 50))
		select @Result = scope_identity()
	end
end

if (lower(@ObjectName) = 'loclocation') begin
	select @Result = ID from LocationLocation where lower(Name) = lower(@ObjectValue)
	if isnull(@Result, 0) < 1 and @IsAutoCreate = 1 and len(@ObjectValue) > 0 begin
		insert into LocationLocation (Name) values (left(@ObjectValue, 50))
		select @Result = scope_identity()
	end
end

if (lower(@ObjectName) = 'locregion') begin
	select @Result = ID from LocationRegion where lower(Name) = lower(@ObjectValue)
	if isnull(@Result, 0) < 1 and @IsAutoCreate = 1 and len(@ObjectValue) > 0 begin
		insert into LocationRegion (Name) values (left(@ObjectValue, 50))
		select @Result = scope_identity()
	end
end

if (lower(@ObjectName) = 'locsite') begin
	select @Result = ID from LocationSite where lower(Name) = lower(@ObjectValue)
	if isnull(@Result, 0) < 1 and @IsAutoCreate = 1 and len(@ObjectValue) > 0 begin
		insert into LocationSite (Name) values (left(@ObjectValue, 50))
		select @Result = scope_identity()
	end
end

if (lower(@ObjectName) = 'locplaces') begin
	select @Result = ID from LocationPlaces where lower(Name) = lower(@ObjectValue)
	if isnull(@Result, 0) < 1 and @IsAutoCreate = 1 and len(@ObjectValue) > 0 begin
		insert into LocationPlaces (Name) values (left(@ObjectValue, 150))
		select @Result = scope_identity()
	end
end

if (lower(@ObjectName) = 'locstate') begin
	select @Result = ID from LocationState where lower(Name) = lower(@ObjectValue)
	if isnull(@Result, 0) < 1 and @IsAutoCreate = 1 and len(@ObjectValue) > 0 begin
		insert into LocationState (Name) values (left(@ObjectValue, 50))
		select @Result = scope_identity()
	end
end

if (lower(@ObjectName) = 'loccity') begin
	select @Result = ID from LocationCity where lower(Name) = lower(@ObjectValue)
	if isnull(@Result, 0) < 1 and @IsAutoCreate = 1 and len(@ObjectValue) > 0 begin
		insert into LocationCity (Name) values (left(@ObjectValue, 150))
		select @Result = scope_identity()
	end
end

-- allow 0 values - each lookup table has an entry with ID = 0
--if isnull(@Result, 0) < 1
--	raiserror('Cannot find or create an entry in the [%s] with value "%s".', 16, 1, @ObjectName, @ObjectValue)
	
RETURN isnull(@Result, 0)
GO
GRANT EXECUTE ON [dbo].[Location_GetLookupID] TO [RP_Customer] AS [dbo]
GO
GRANT EXECUTE ON [dbo].[Location_GetLookupID] TO [RP_DataAdmin] AS [dbo]
GO
