
-------------------------------------------------------------------------------------------------------
--show
-------------------------------------------------------------------------------------------------------
--showmulti     showstuff     showvalues     showSamples     [=] 
CREATE proc [dbo].[show] (@tableName nvarChar(max), @where nvarChar(max) = '', @minValueCount int = 1)
as begin
 
--declare @tableName nvarChar(max)='wh', @where nvarChar(max) = 'tz where whN<50', @minValueCount int = 2
--declare @tableName nvarChar(max)='a3', @where nvarChar(max) = 't', @minValueCount int = 2
 
set noCount on
if ISNULL(@minValueCount, 0) < 1 set @minValueCount = 2
declare @s nvarchar(999), @columns nvarchar(999) = '', @r int
 
declare @columnCount int, @i int = 1, @columnName nvarchar(200), @dataType nvarChar(30), @where2 nvarChar(999), @where1 nvarChar(999)
declare @countZeros bit = 0, @mapWh bit = 0
select @columnCount = MAX(ordinal_position) from INFORMATION_SCHEMA.columns where table_name = @tableName
 
set @tableName = ltrim(rtrim(@tableName))
set @where = ltrim(rtrim(@where))
set @r = patIndex(N'%where%', @where)
if @r > 0
	begin
		set @s = ' ' + left(@where, @r-1)
		set @where = right(@where, len(@where) - @r + 1)
	end
else
	begin
		set @s = @where
		set @where = ''
	end
if @s like '%[Zz]%' set @countZeros = 1
if @s like '%[Tt]%' set @mapWh = 1
 
 
set @s = N'select @r = count(*) from ' + @tableName + ' ' +@where
exec sp_executeSQL @s, N'@r int output', @r output;
if @r = 1 set @minValueCount = 1
 
while @i <= @columnCount
	begin
		select @columnName = column_name, @dataType = data_type  from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = @tableName and ORDINAL_POSITION = @i
		if @countZeros <> 0
			set @where2 = ' ' + @columnName+' is not null '
		else
			set @where2 = ' isNull(' + @columnName+', 0) <> 0 '
		
		if @dataType not in ('rowVersion','timeStamp')
			begin
				if @dataType not in ('bigint','bit','decimal','float','int','money','numeric','real','smallint','smallmoney','tinyint')
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
						if @mapWh = 1 and @columnName in ('whN', '_bottleWhN', 'pubN', 'pubGN', 'masterPubN','defaultPubN', 'createWhN', 'updateWhN', '' )
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
set @s = 'Select ' + @columns + ' from ' + @tableName + ' ' + @where
print @s
exec (@s)
 
set noCount off
end
 
 
 
