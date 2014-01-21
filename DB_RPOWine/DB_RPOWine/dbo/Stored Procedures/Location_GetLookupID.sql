CREATE PROCEDURE [dbo].[Location_GetLookupID]
	@ObjectName as varchar(30), @ObjectValue as nvarchar(120),
	@IsAutoCreate bit = 1

--
-- Gets ID of the lookup record if exists or creates a new entry and returns new ID.
-- Location lookups are essentially cache tables, therefore "cache rules" - auto create - are applied by default.
--

AS
set nocount on

declare @Result int
set @ObjectValue = ltrim(rtrim(@ObjectValue))

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

if isnull(@Result, 0) < 1
	raiserror('Cannot find or create an entry in the [%s] with value "%s".', 16, 1, @ObjectName, @ObjectValue)
	
RETURN isnull(@Result, 0)
GO
GRANT EXECUTE ON [dbo].[Location_GetLookupID] TO [RP_Customer] AS [dbo]
GO
GRANT EXECUTE ON [dbo].[Location_GetLookupID] TO [RP_DataAdmin] AS [dbo]
GO
