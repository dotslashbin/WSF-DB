CREATE PROCEDURE [dbo].[Audit_GetList]
	@ID int = NULL,
	@EntryDate datetime = NULL, @Type varchar(50) = NULL, @Category varchar(50) = NULL, 
	@Source varchar(50) = NULL, @UserName varchar(50) = NULL, @MachineName varchar(50) = NULL, 
	@ObjectType varchar(50) = NULL, @ObjectID varchar(80) = NULL,
	@Description nvarchar(256) = NULL, @Message ntext = NULL,
	
	@DateOpFrom smalldatetime = NULL, @DateOpTo smalldatetime = NULL,
	@StartRow int = NULL, @EndRow int = NULL,
	@ShowRes smallint = 1

/*
exec Audit_GetList @ObjectType='WineProducer', @Message='"name": "Test'
*/

AS
set nocount on

declare @TotalCount int

if @ID is NOT NUll and @ID < 0
	set @ID = NULL

if @ID is NULL and @EntryDate is NULL and @Type is NULL and @Category is NULL 
	and @Source is NULL and @UserName is NULL and @MachineName is NULL 
	and	@ObjectType is NULL and @ObjectID is NULL 
	and @Description is NULL and @Message is NULL
	and @DateOpFrom is NULL and @DateOpTo is NULL begin
	
	raiserror('[USERERROR]: At least one filter parameter must be specified.', 16, 1)
	RETURN -1
end

if @DateOpTo is NOT NULL and datepart(hour,@DateOpFrom)=0 and datepart(minute,@DateOpFrom)=0
	and datepart(hour,@DateOpTo)=0 and datepart(minute,@DateOpTo)=0
	select @DateOpTo = dateadd(minute, 23*60+59, @DateOpTo)

if datalength(@Message) > 0 begin
	declare @searchStr nvarchar(256)
	set @searchStr = '%' + replace(substring(@Message, 0, 253), '[', '[[]') + '%'

	select @TotalCount = count(*)
	from Audit a (nolock)
		join Audit_EntryTypes at (nolock) on a.TypeID = at.ID
		join Audit_EntryCategories ac (nolock) on a.CategoryID = ac.ID
		--join Audit_EntrySources s (nolock) on a.SourceID = s.ID
		join Audit_EntryUsers au (nolock) on a.UserNameID = au.ID
		--join Audit_EntryMachines am (nolock) on a.MachineNameID = am.ID
		join Audit_ObjectTypes aot (nolock) on a.ObjectTypeID = aot.ID
	where a.ID = isnull(@ID, a.ID) 
		and EntryDate >= isnull(@EntryDate, '1/1/2000') 
		and upper(at.Name) = upper(isnull(@Type, at.Name)) 
		and upper(ac.Name) = upper(isnull(@Category, ac.Name)) 
		and upper(aot.Name) = upper(isnull(@ObjectType, aot.Name)) 
		and upper(ObjectID) = upper(isnull(@ObjectID, ObjectID)) 
		and upper(au.Name) = upper(isnull(@UserName, au.Name)) 
		and Message like @searchStr
		and (@DateOpFrom is NULL or @DateOpTo is NULL or (EntryDate >= @DateOpFrom and EntryDate <= @DateOpTo))

	; with r as (
		select
			ID = a.ID, 
			EntryDate, 
			Type = at.Name, 
			Category = ac.Name, 
			Source = s.Name, 
			UserName = au.Name, 
			MachineName = am.Name, 
			ObjectType = aot.Name, 
			ObjectID, 
			Description,
			Message = case when isnull(@ShowRes, 0) = 2 then '' else Message end,
			RowNumber = row_number() over (order by a.ID desc),
			TotalCount = isnull(@TotalCount, 0)
		from Audit a (nolock)
			join Audit_EntryTypes at (nolock) on a.TypeID = at.ID
			join Audit_EntryCategories ac (nolock) on a.CategoryID = ac.ID
			join Audit_EntrySources s (nolock) on a.SourceID = s.ID
			join Audit_EntryUsers au (nolock) on a.UserNameID = au.ID
			join Audit_EntryMachines am (nolock) on a.MachineNameID = am.ID
			join Audit_ObjectTypes aot (nolock) on a.ObjectTypeID = aot.ID
		where a.ID = isnull(@ID, a.ID) 
			and EntryDate >= isnull(@EntryDate, '1/1/2000') 
			and upper(at.Name) = upper(isnull(@Type, at.Name)) 
			and upper(ac.Name) = upper(isnull(@Category, ac.Name)) 
			and upper(aot.Name) = upper(isnull(@ObjectType, aot.Name)) 
			and upper(ObjectID) = upper(isnull(@ObjectID, ObjectID)) 
			and upper(au.Name) = upper(isnull(@UserName, au.Name)) 
			and Message like @searchStr
			and (@DateOpFrom is NULL or @DateOpTo is NULL or (EntryDate >= @DateOpFrom and EntryDate <= @DateOpTo))
	)
	select top 300 * from r
	where (@StartRow is NULL or @EndRow is NULL or (RowNumber between @StartRow and @EndRow))
	order by ID desc

end else begin
	select @TotalCount = count(*)
	from Audit a (nolock)
		join Audit_EntryTypes at (nolock) on a.TypeID = at.ID
		join Audit_EntryCategories ac (nolock) on a.CategoryID = ac.ID
		--join Audit_EntrySources s (nolock) on a.SourceID = s.ID
		join Audit_EntryUsers au (nolock) on a.UserNameID = au.ID
		--join Audit_EntryMachines am (nolock) on a.MachineNameID = am.ID
		join Audit_ObjectTypes aot (nolock) on a.ObjectTypeID = aot.ID
	where a.ID = isnull(@ID, a.ID) 
		and EntryDate >= isnull(@EntryDate, '1/1/2000') 
		and upper(at.Name) = upper(isnull(@Type, at.Name)) 
		and upper(ac.Name) = upper(isnull(@Category, ac.Name)) 
		and upper(aot.Name) = upper(isnull(@ObjectType, aot.Name)) 
		and upper(ObjectID) = upper(isnull(@ObjectID, ObjectID)) 
		and upper(au.Name) = upper(isnull(@UserName, au.Name))
		and (@DateOpFrom is NULL or @DateOpTo is NULL or (EntryDate >= @DateOpFrom and EntryDate <= @DateOpTo))

	; with r as (
		select 
			ID = a.ID, 
			EntryDate, 
			Type = at.Name, 
			Category = ac.Name, 
			Source = s.Name, 
			UserName = au.Name, 
			MachineName = am.Name, 
			ObjectType = aot.Name, 
			ObjectID, 
			Description,
			Message = case when isnull(@ShowRes, 0) = 2 then '' else Message end,
			RowNumber = row_number() over (order by a.ID desc),
			TotalCount = isnull(@TotalCount, 0)
		from Audit a (nolock)
			join Audit_EntryTypes at (nolock) on a.TypeID = at.ID
			join Audit_EntryCategories ac (nolock) on a.CategoryID = ac.ID
			join Audit_EntrySources s (nolock) on a.SourceID = s.ID
			join Audit_EntryUsers au (nolock) on a.UserNameID = au.ID
			join Audit_EntryMachines am (nolock) on a.MachineNameID = am.ID
			join Audit_ObjectTypes aot (nolock) on a.ObjectTypeID = aot.ID
		where a.ID = isnull(@ID, a.ID) 
			and EntryDate >= isnull(@EntryDate, '1/1/2000') 
			and upper(at.Name) = upper(isnull(@Type, at.Name)) 
			and upper(ac.Name) = upper(isnull(@Category, ac.Name)) 
			and upper(aot.Name) = upper(isnull(@ObjectType, aot.Name)) 
			and upper(ObjectID) = upper(isnull(@ObjectID, ObjectID)) 
			and upper(au.Name) = upper(isnull(@UserName, au.Name))
			and (@DateOpFrom is NULL or @DateOpTo is NULL or (EntryDate >= @DateOpFrom and EntryDate <= @DateOpTo))
	)
	select top 300 * from r
	where (@StartRow is NULL or @EndRow is NULL or (RowNumber between @StartRow and @EndRow))
	order by ID desc

end

RETURN 1
GO
GRANT EXECUTE
    ON OBJECT::[dbo].[Audit_GetList] TO [RP_DataAdmin]
    AS [dbo];

