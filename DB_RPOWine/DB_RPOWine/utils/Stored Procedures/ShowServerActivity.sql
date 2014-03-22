CREATE PROCEDURE [utils].[ShowServerActivity] 
	@TraceDuration int = 15,  --trace duration in seconds
	@FName nvarchar(100) = N'C:\MSSQL\TRACE\ShowServerActivity',
	@maxfilesize bigint = 5 ,--maximum size in megabytes 
	@FilterDBName nvarchar(50)= null,--optional db name to restrict trace to specific db
	@IsDebug smallint = 0
AS
BEGIN
/****************************************************/
/* Created by: SQL Server Profiler 2005             */
/* Date: 09/16/2008  04:46:30 PM         */
/****************************************************/
/*
exec [utils].[ShowServerActivity] @TraceDuration = 15, @FName = N'C:\ShowServerActivity',
	@FilterDBName = 'RPOWineData'

ms-help://MS.SQLCC.v9/MS.SQLSVR.v9.en/tsqlref9/html/7662d1d9-6d0f-443a-b011-c901a8b77a44.htm

select * from ::fn_Trace_GetInfo(null)
select EventClass,EventSubClass,TextData, NTUserName,ClientProcessID,ApplicationName,LoginName,SPID,Duration,StartTime,Reads,Writes,CPU
from ::fn_trace_gettable('c:\perflogs\trace_1.trc',default)

exec sp_trace_setstatus 2, 0 --stop
exec sp_trace_setstatus 2, 1 --start
exec sp_trace_setstatus 2, 2 --close the trace and delete its information from the server
*/

	-- Create a Queue
	declare @rc int
	declare @TraceID int
	declare @stoptime datetime
	declare @stoptimeStr nvarchar(19)

	select @stoptime = dateadd(ss,@TraceDuration,getdate())
	select @stoptimeStr = convert(varchar(19),@stoptime,121 )
	select @FName = @FName  + replace(replace(replace(@stoptimeStr,'-',''),' ',''),':','')
	if @IsDebug = 1
		print 'trace stop time is ' + @stoptimeStr + ' trace file name @FName is ' + @FName
	exec @rc = sp_trace_create @traceid = @TraceID output, 
							@options = 0, 
							@tracefile = @FName, 
							@maxfilesize = @maxfilesize, 
							@stoptime = @stoptime,
							@filecount = NULL
	if @IsDebug = 1
		print 'trace created. trace id is ' + cast(@TraceID as varchar(10))

	if (@rc != 0) 
	begin
		raiserror ('ShowServerActivity :: Error: return code of sp_trace_create <> 0, @rc = %d',16,1,@rc)
		return @rc
	end
	-- Client side File and Table cannot be scripted
	-- Set the events
	declare @on bit
	set @on = 1
	--ExistingConnection

	exec sp_trace_setevent @TraceID, 17, 1, @on		--TextData
	exec sp_trace_setevent @TraceID, 17, 6, @on		--NTUserName
	exec sp_trace_setevent @TraceID, 17, 9, @on		--ClientProcessID
	exec sp_trace_setevent @TraceID, 17, 10, @on	--ApplicationName
	exec sp_trace_setevent @TraceID, 17, 11, @on	--LoginName 
	exec sp_trace_setevent @TraceID, 17, 12, @on	--SPID
	exec sp_trace_setevent @TraceID, 17, 14, @on	--StartTime
	--exec sp_trace_setevent @TraceID, 17, 27, @on	--EventClass

	--RPC:Completed
	exec sp_trace_setevent @TraceID, 10, 1, @on		--TextData
	exec sp_trace_setevent @TraceID, 10, 6, @on		--NTUserName
	exec sp_trace_setevent @TraceID, 10, 9, @on		--ClientProcessID
	exec sp_trace_setevent @TraceID, 10, 10, @on	--ApplicationName
	exec sp_trace_setevent @TraceID, 10, 11, @on	--LoginName
	exec sp_trace_setevent @TraceID, 10, 12, @on	--SPID
	exec sp_trace_setevent @TraceID, 10, 13, @on	--Duration
	exec sp_trace_setevent @TraceID, 10, 14, @on	--StartTime
	exec sp_trace_setevent @TraceID, 10, 16, @on	--Reads
	exec sp_trace_setevent @TraceID, 10, 17, @on	--Writes
	exec sp_trace_setevent @TraceID, 10, 18, @on	--CPU
	exec sp_trace_setevent @TraceID, 10, 35, @on	--DatabaseName
	--exec sp_trace_setevent @TraceID, 10, 27, @on	--EventClass
	--SQL:BatchCompleted
	exec sp_trace_setevent @TraceID, 12, 1, @on		--TextData
	exec sp_trace_setevent @TraceID, 12, 6, @on		--NTUserName
	exec sp_trace_setevent @TraceID, 12, 9, @on		--ClientProcessID
	exec sp_trace_setevent @TraceID, 12, 10, @on	--ApplicationName
	exec sp_trace_setevent @TraceID, 12, 11, @on	--LoginName
	exec sp_trace_setevent @TraceID, 12, 12, @on	--SPID
	exec sp_trace_setevent @TraceID, 12, 13, @on	--Duration
	exec sp_trace_setevent @TraceID, 12, 14, @on	--StartTime
	exec sp_trace_setevent @TraceID, 12, 16, @on	--Reads
	exec sp_trace_setevent @TraceID, 12, 17, @on	--Writes
	exec sp_trace_setevent @TraceID, 12, 18, @on	--CPU
	exec sp_trace_setevent @TraceID, 12, 35, @on	--DatabaseName
	--exec sp_trace_setevent @TraceID, 12, 27, @on	--EventClass


	-- Set the Filters
	declare @intfilter int
	declare @bigintfilter bigint

	exec sp_trace_setfilter @TraceID, 10, 0, 7, N'SQL Server Profiler - 23f61735-f195-41a7-8a61-db8ddf356c70'
	exec sp_trace_setfilter @TraceID, 10, 0, 7, N'Microsoft® Windows® Operating System'
	exec sp_trace_setfilter @TraceID, 10, 0, 7, N'SQLAgent%'
	if isnull(@FilterDBName ,'')<>''
	begin
		exec sp_trace_setfilter @TraceID, 10, 0, 7, N'Microsoft SQL Server Management Studio - Transact-SQL IntelliSense'
		exec sp_trace_setfilter @TraceID, 35, 0, 6, @FilterDBName
	end

	-- Set the trace status to start
	exec sp_trace_setstatus @TraceID, 1
	select @FName = @FName + '.trc' -- .trc added by sql trace
	print 'select DatabaseName,EventClass,EventSubClass,TextData, NTUserName,ClientProcessID,ApplicationName,LoginName,SPID,Duration,StartTime,Reads,Writes,CPU
	from ::fn_trace_gettable('''+@FName+''',default)'
	raiserror('waiting for trace stop time %s before returning result',0,1,@stoptimeStr) with nowait
	WAITFOR TIME @stoptime
	select DatabaseName,EventClass,EventSubClass,TextData, NTUserName,ClientProcessID,ApplicationName,LoginName,SPID,Duration,StartTime,Reads,Writes,CPU
	from ::fn_trace_gettable(@FName,default)

END