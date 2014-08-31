----------------------------------------------------------
--showmulti     showstuff     showvalues     showSamples     [=] 
CREATE proc [dbo].[oss] (@tableName nvarChar(max), @where nvarChar(max) = '', @minValueCount int = null)
as begin
 
--declare @tableName nvarChar(max)='pubGToPub', @where nvarChar(max) = 'where pubGN=18241 order by isDerived', @minValueCount int = 1
--declare @tableName nvarChar(max)='a3', @where nvarChar(max) = 'N', @minValueCount int = 2
 
set noCount on
if ISNULL(@minValueCount, 0) < 1 set @minValueCount = 2
declare @s nvarchar(999), @columns nvarchar(999) = '', @r int, @rr int, @orderBy nvarchar(max) = ''
 
declare @columnCount int, @i int = 1, @columnName nvarchar(200), @dataType nvarChar(30), @where2 nvarChar(999), @where1 nvarChar(999)
declare @countZeros bit = 0, @mapWh bit = 0
select @columnCount = MAX(ordinal_position) from INFORMATION_SCHEMA.columns where table_name = @tableName
 
set @tableName = ltrim(rtrim(@tableName))
set @where = ' ' + ltrim(rtrim(@where)) + ' '
 
set @r = patIndex(N'% order by %', @where)
if @r > 0
	begin
		set @rr = len(@where) - @r + 2
		if @rr > len(@where) set @rr = len(@where)
		set @orderBy = right(@where, @rr)
		set @where = ' ' + left(@where, @r)
	end
 
set @r = patIndex(N'%where%', @where)
if @r > 0
	begin
		set @rr = len(@where) - @r + 2
		if @rr > len(@where) set @rr = len(@where)
		set @s = ' ' + left(@where, @r-1)
		set @where = right(@where, @rr)
	end
else
	begin
		set @s = @where
		set @where = ''
	end
if @s like '%[Zz]%' set @countZeros = 1
if @s like '%[Nn]%' set @mapWh = 1
 
 
set @s = N'select @r = count(*) from ' + @tableName + ' ' +@where
exec sp_executeSQL @s, N'@r int output', @r output;
if @r = 0 begin
	select 'No records found'
	return
	end
if @r = 1 set @minValueCount = 1
 
while @i <= @columnCount
	begin
		select @columnName = column_name, @dataType = data_type  from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = @tableName and ORDINAL_POSITION = @i
		--if @countZeros <> 0
		if @countZeros <> 0 or @dataType  not in ('bigint','bit','decimal','float','int','money','numeric','real','smallint','smallmoney','tinyint')
			set @where2 = ' ' + @columnName+' is not null '
		else
			set @where2 = ' isNull(' + @columnName+', 0) <> 0 '
		
		if @dataType not in ('rowVersion','timeStamp')
			begin
				if @dataType not in ('bigint','bit','decimal','float','int','money','numeric','real','smallint','smallmoney','tinyint','time','date','smalldatetime','datetime','datetime2','datetimeoffset')
					begin
						If @dataType in ('char','nchar','ntext','nvarchar','text','varchar')
							set @where2 = ' len(' + @columnName + ') > 0 '
					end
				
				if LEN(@where2) > 0
					begin
						if @where like '%where%'
							set @where1 = @where + ' and ' + @where2 
						else
							set @where1 = ' where ' +	@where2
					end
				else
					set @s = @where1 + ' ' + @columnName + ' is not null '
			
				select @s = 'select @r = count(distinct('+@columnName+')) from '+@tableName+' ' + @where1
				
				exec sp_executeSQL @s, N'@r int output', @r output;
				
				if @r >= @minValueCount
					begin
						if @mapWh = 1 and @columnName in ('whN', '_bottleWhN', 'pubN', 'pubGN', 'masterPubN','defaultPubN', 'createWhN', 'updateWhN', 'tasterN', 'trustedN', 'toN' )
							begin
								set @s = ' dbo.getName2('+@columnName + ')' + @columnName+','
								--print @s
								set @columns += @s
							end
						else
							set @columns += (@columnName + ',')
					end
			end		
			
		set @i += 1
	end
 
set @columns = LEFT(@columns, len(@columns) - 1) 
set @s = 'Select ' + @columns + ' from ' + @tableName + ' ' + @where + @orderBy
print @s
exec (@s)
 
set noCount off
 
/*
showStuff wh
go
showStuff wh, '0'
 
showStuff wh,'where whN <=30'
go
showStuff wh,'0 where whN <=30'
 
 
go
showvalues wh
 
select * into a3 from wh where whN <=30
 
showStuff a3, '0 where 1=1', 1
showStuff a3, 'where 1=1', 1
 
showStuff a3, 0, 1
go
showStuff a3, '0', 1
 
showStuff a3, '', 1
 
 
showStuff a3,a,1
showStuff a3,z,1
showStuff a3,'0',1
 
 
*/
 
 
end
 
 
 
 
 
 
 
