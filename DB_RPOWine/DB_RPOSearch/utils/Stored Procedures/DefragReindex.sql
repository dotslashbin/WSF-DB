CREATE PROCEDURE [utils].[DefragReindex]
        @DBName varchar(255),
        @TableName varchar(255) = NULL, -- will perform operation for ALL tables within database if NULL 
        @MaxFrag int = 10,				-- max logical fragmentation percent allowed
        @Mode varchar(10) = 'report',	-- report,defrag,rebuild,reb/def
		@IsIncludeClustIndexes smallint = 1,	-- 0 will skip clustered indexes (useful for auto incremented indices)
		@IsDebug smallint = 0,			-- 0 do not debug, 1 - debug mode & messages
		@IsShowInfoMsg smallint = 0		-- 0 do not show info messages, 1 show info messages

--
-- Rebuild consistes of 3 steps: 
-- 1. Index Rebuild
-- 2. Index Reorganize
-- 3. Update Statistics
--

AS
set nocount on

---------------------------- Checks --------------------------
select @DBName = ltrim(rtrim(@DBName)), @TableName = ltrim(rtrim(@TableName))

if @Mode NOT IN ('report', 'defrag', 'rebuild', 'reb/def') begin
    raiserror('tools_DefragReindex.ERROR:: Invalid mode specified (%s), must be ''report'', ''defrag'', ''rebuild'' or ''reb/def''.', 16, 1, @Mode)
    RETURN -1
end
if isnull(@DBName ,'') = '' begin
	raiserror('tools_DefragReindex.ERROR:: @DBName is empty.',16,1)
	return -10
end
if DB_ID(@DBName) is null begin
	raiserror('tools_DefragReindex.ERROR:: Invalid database specified (%s).', 16, 1, @DBName)
	RETURN -1
end
if lower(@DBName) in ('master', 'msdb', 'model', 'tempdb') begin
	raiserror('tools_DefragReindex.ERROR:: This procedure cannot be run in system databases. Invalid database specified (%s).', 16, 1, @DBName)
	RETURN -1
end
if @MaxFrag < 0 OR @MaxFrag > 100 or @MaxFrag is null begin
	raiserror('tools_DefragReindex.ERROR:: MaxFrag must be between 0 and 100. Invalid @MaxFrag specified (%d).', 16, 1, @MaxFrag  )
	RETURN -1
end
---------------------------- Checks --------------------------
declare @Command varchar(1024)

if @Mode = 'report' begin
	select @Command = 'USE ' + rtrim(@DBName)
		+ ' select 
			TableName = QUOTENAME(OBJECT_SCHEMA_NAME(s.object_id, s.database_id)) 
				+ N''.'' + QUOTENAME(OBJECT_NAME(s.object_id, s.database_id)),
			IndexName = isnull(i.name, ''''),
			s.*
		from sys.dm_db_index_physical_stats(DB_ID(''' + rtrim(@DBName) + '''), NULL, NULL, NULL , ''DETAILED'') s
			left join sys.indexes i on s.object_id = i.object_id and s.index_id = i.index_id
		where avg_fragmentation_in_percent > ' + cast(@MaxFrag as varchar(20)) -- and record_count > 100
			+ case when @IsIncludeClustIndexes = 0 then ' and s.index_type_desc != ''CLUSTERED INDEX''' else '' end
		+ ' order by --TableName
			avg_fragmentation_in_percent desc, record_count desc;
		'
	exec(@Command)
end else begin
	declare @IndexName varchar(255),
			@FragPercent decimal

	CREATE TABLE #FragList (
	   TableName char(255),
	   IndexName char(255),
	   ObjectID int,
	   IndexID int,
	   FragPercent decimal)

	select @Command = 'USE ' + rtrim(@DBName)
		+ ' select 
			TableName = QUOTENAME(OBJECT_SCHEMA_NAME(s.object_id, s.database_id)) 
				+ N''.'' + QUOTENAME(OBJECT_NAME(s.object_id, s.database_id)),
			IndexName = isnull(i.name, ''''),
			s.object_id, s.index_id, s.avg_fragmentation_in_percent
		from sys.dm_db_index_physical_stats(DB_ID(''' + rtrim(@DBName) + '''), NULL, NULL, NULL , ''DETAILED'') s
			left join sys.indexes i on s.object_id = i.object_id and s.index_id = i.index_id
		where avg_fragmentation_in_percent > ' + cast(@MaxFrag as varchar(20)) + ' and record_count > 100'
			+ case when @IsIncludeClustIndexes = 0 then ' and s.index_type_desc != ''CLUSTERED INDEX''' else '' end
		+ ' order by --TableName
			avg_fragmentation_in_percent desc, record_count desc;
		'
	insert into #FragList(TableName, IndexName, ObjectID, IndexID, FragPercent)
	exec(@Command)

	if (@IsDebug = 1) begin
		select * from #FragList order by FragPercent desc, TableName, IndexName
	end

	------------ do the job -----------
	declare cr cursor read_only forward_only for
		select TableName, IndexName, FragPercent
		from #FragList
		order by TableName
	open cr
	fetch next from cr into @TableName, @IndexName, @FragPercent
	while @@FETCH_STATUS = 0 begin
		if @Mode in ('rebuild', 'reb/def') begin
			-- 1. Index Rebuild
			select @Command = 'USE ' + rtrim(@DBName) 
				+ ' ALTER INDEX ' + QUOTENAME(rtrim(@IndexName)) + ' ON ' + rtrim(@TableName) + ' REBUILD WITH (SORT_IN_TEMPDB = ON);'
			if @IsDebug = 1
				select [@Command] = @Command
			if (@IsDebug = 1) or (@IsShowInfoMsg = 1)
				print 'Executing ALTER INDEX (REBUILD) ON ' + rtrim(@TableName) + '.' + QUOTENAME(rtrim(@IndexName))
					+ ' - current fragmentation is ' + rtrim(convert(varchar(15),@FragPercent)) + '%'
			exec(@Command)
		end

		if @Mode in ('defrag', 'reb/def') begin
			-- 2. Index Reorganize
			select @Command = 'USE ' + rtrim(@DBName) 
				+ ' ALTER INDEX ' + QUOTENAME(rtrim(@IndexName)) + ' ON ' + rtrim(@TableName) + ' REORGANIZE;'
			if @IsDebug = 1
				select [@Command] = @Command
			if (@IsDebug = 1) or (@IsShowInfoMsg = 1)
				print 'Executing ALTER INDEX (REORGANIZE) ON ' + rtrim(@TableName) + '.' + QUOTENAME(rtrim(@IndexName))
					+ ' - current fragmentation is ' + rtrim(convert(varchar(15),@FragPercent)) + '%'
			exec(@Command)
		end

		-- 3. Update Statistics
		select @Command = 'USE ' + rtrim(@DBName) 
			+ ' UPDATE STATISTICS ' + rtrim(@TableName) + ' ' + QUOTENAME(rtrim(@IndexName)) + ' WITH FULLSCAN;'
		if @IsDebug = 1
			select [@Command] = @Command
		if (@IsDebug = 1) or (@IsShowInfoMsg = 1)
			print 'Executing UPDATE STATISTICS ' + rtrim(@TableName) + ' ' + rtrim(@IndexName) + ' WITH FULLSCAN'
		exec(@Command)

		fetch next from cr into @TableName, @IndexName, @FragPercent
	end
	close cr
	deallocate cr

	drop table #FragList
end

RETURN 1