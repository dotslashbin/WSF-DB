
CREATE PROCEDURE [utils].[sp_who_active]
	@ActiveOnly int = 0

-- procedure will show active connections to the server excluding system processes
AS
SET NOCOUNT ON
DECLARE @spid int,
	@Result int
---------------- Get SQL Statement for each connection -----------------------------
DECLARE @sqlstring varchar(250),
	@cr CURSOR
CREATE TABLE #temp (
	ID int IDENTITY (0, 1) NOT NULL,
	EventType nvarchar(30) NULL, 
	Parameters int NULL, 
	EventInfo nvarchar(4000),
	PID int NULL
)
set @cr = CURSOR forward_only FOR
	SELECT	spid
	FROM	master.dbo.sysprocesses sproc (nolock)
		join master.dbo.sysdatabases sdb (nolock) on sproc.dbid = sdb.dbid
	WHERE	cmd <> 'awaiting command' AND spid >5
		/** Inactive and system processes are excluded ***/
OPEN @cr
FETCH NEXT FROM @cr INTO @spid
WHILE @@fetch_status = 0
BEGIN
	SET @sqlstring = 'DBCC INPUTBUFFER (' + CAST(@spid AS CHAR(4)) + ') WITH NO_INFOMSGS'
	INSERT #temp (EventType, Parameters, EventInfo)
		EXEC (@sqlstring)
	select @Result = MAX(ID) from #temp
	update #temp set PID = @spid where ID = @Result
	FETCH NEXT FROM @cr INTO @spid
END
CLOSE @cr
DEALLOCATE @cr
------------------------ Get statistical process information ------------------------------
if @ActiveOnly = 1 begin
	SELECT distinct
		sproc.spid,
		DBName = cast(isnull(sdb.name, '') as varchar(20)),
		Login = cast(sproc.loginame as varchar(20)),
		status = left(sproc.status,10),
		sproc.cmd,
		sproc.blocked,
		sproc.cpu,
		sproc.physical_io,
		sproc.memusage,
		hostname = cast(sproc.hostname as char(12)),
		program_name = CAST(sproc.program_name AS char(40)),
		EventType = t.EventType,
		EventInfo = rtrim(cast(t.EventInfo as char(150))) + case
			when len(rtrim(isnull(t.EventInfo, ''))) > 150 then '...'
			else '   '
		end,
		sproc.waittime,
		waitresource = convert(varchar(16), sproc.waitresource),
		sproc.open_tran,
		WindowsProcID = sproc.kpid
	FROM	master.dbo.sysprocesses sproc (nolock)
		left join master.dbo.sysdatabases sdb (nolock) on sproc.dbid = sdb.dbid
		left join #temp t (nolock) on sproc.spid = t.PID
	WHERE lower(cmd) <> 'awaiting command'   /** Inactive processes are excluded ***/
		AND spid >5  /*** System processes are excluded ***/
		and sproc.cmd <> 'DB MIRROR'
	order by DBName, Login
end else begin
	SELECT distinct
		sproc.spid,
		DBName = cast(isnull(sdb.name, '') as char(12)),
		Login = cast(sproc.loginame as varchar(20)),
		status = left(sproc.status,10),
		sproc.cmd,
		sproc.blocked,
		sproc.cpu,
		sproc.physical_io,
		sproc.memusage,
		hostname = cast(sproc.hostname as char(12)),
		program_name = CAST(sproc.program_name AS char(40)),
		EventType = t.EventType,
		EventInfo = rtrim(cast(t.EventInfo as char(150))) + case
			when len(rtrim(isnull(t.EventInfo, ''))) > 150 then '...'
			else '   '
		end,
		sproc.waittime,
		waitresource = convert(varchar(16), sproc.waitresource),
		sproc.open_tran,
		WindowsProcID = sproc.kpid
	FROM	master.dbo.sysprocesses sproc (nolock)
		left join master.dbo.sysdatabases sdb (nolock) on sproc.dbid = sdb.dbid
		left join #temp t (nolock) on sproc.spid = t.PID
	WHERE spid >5  /*** System processes are excluded ***/
	order by DBName, Login
end
DROP TABLE #temp
SET NOCOUNT OFF
RETURN 1