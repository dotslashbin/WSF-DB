
-------------------------------------------------------------------------------------------------------
--showv
-------------------------------------------------------------------------------------------------------
--33
--showmulti     showStuff     showValues     [=]
CREATE proc [dbo].[showv] (@tableName nvarChar(max), @where nvarChar(max) = '', @minValueCount int = 2, @maxRows int = 100)
as begin
--declare @tableName nvarChar(max)='wh', @where nvarChar(max) = 't where whN in (1,2,17129)', @minValueCount int = 2, @maxRows int = 100
set noCount on
if ISNULL(@minValueCount, 0) < 1 set @minValueCount = 2
 
declare @s nvarchar(999), @r int,@columns nvarchar(max) = '', @columnsPadded nvarchar(max) = '', @columnCount int, @i int = 1, @columnName nvarchar(200), @createTemp nvarchar(max), @dataType nvarChar(30)
declare @countZeros bit = 0, @mapWh bit = 0, @value nvarchar(max) = ''
 
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
 
begin try
	if not @minValueCount >=  1 set @minValueCount = 2
end try
begin catch
	set @minValueCount = 2
end catch
 
set @createTemp = ('Select Top ' + convert(nvarchar,@maxRows) + ' 12345 ii, ')
 
declare @where1 nvarChar(200), @where2 nvarChar(200)
select @columnCount = MAX(ordinal_position) from INFORMATION_SCHEMA.columns where table_name = @tableName
 
begin try
	drop table [{tempShowValues}]
end try begin catch end catch
 
-----------------------------------------------------------------------------------------------------------
--Get occupied columns
-----------------------------------------------------------------------------------------------------------
set @i = 1
while @i <= @columnCount
	begin
		select @where2 = '', @columnName = column_name, @dataType = data_type  from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = @tableName and ORDINAL_POSITION = @i
		
		-------------------------------------------------------------------
		if @columnName like '%fullName%'
			print @columnName
		-------------------------------------------------------------------
				
		if @dataType not in ('rowVersion','timeStamp')
			begin
				if @dataType in ('bigint','bit','decimal','float','int','money','numeric','real','smallint','smallmoney','tinyint')
					set @where2 = ' '+@columnName+' is not null'					--                 ' isNull(' + @columnName + ',0) <> 0'
				else
					begin
						If @dataType in ('char','nchar','ntext','nvarchar','text','varchar')
							set @where2 = ' len(' + @columnName + ') > 0'
						else
							set @where2 = ' ' +  @columnName + ' is not null '
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
						set @columnsPadded += convert(nchar(100),@columnName)
						set @createTemp += ' convert(nvarchar(max), '''') ' + @columnName + ','
					end
			end		
		
			
		set @i += 1
	end
 
 
-----------------------------------------------------------------------------------------------------------
--Create the table that will hold the examples
-----------------------------------------------------------------------------------------------------------
 
set @createTemp = LEFT(@createTemp, len(@createTemp) - 1) +  + ' into [{tempShowValues}] from ' + @tableName
exec (@createTemp);
 
with 
	a as (select ROW_NUMBER() over (order by ii) iRow2, * from [{tempShowValues}])
update a set ii = iRow2
			
 
 
 
-----------------------------------------------------------------------------------------------------------
--Fill in the values for each column
-----------------------------------------------------------------------------------------------------------
set @i = 1
while @i <= @columnCount
	begin
		set @columnName = rTrim(SUBSTRING(@columnsPadded, 1 + 100 * (@i - 1), 100));
		if len(@columnName) = 0 break
		
		set @value =	   'b.v';
		if @mapWh = 1 and @columnName in ('whN', '_bottleWhN', 'pubN', 'pubGN', 'masterPubN','defaultPubN', 'createWhN', 'updateWhN', '' )
				set @value = ' dbo.getName2(b.v)'
 
		set @s = 
				'with
					 d as (select * from '+@tableName+' '+@where+')
					,a as (select isNull(convert(nvarchar,'+@columnName+'), ''(null)'') v, count(*) cnt from d group by '+@columnName+') 
					,b as (select row_number() over (order by cnt desc) ii, v, cnt from a)
				update c set c.'+@columnName+' = (convert(nvarchar,'+@value+') + ''  ('' + convert(nvarchar,cnt) + '')'') 
					from [{tempShowValues}] c 
						join b	 on c.ii = b.ii'		
 
		begin try
		exec (@s)
		end try
		begin catch
			set @r = @r
		end catch
 
		/*set @s = 
				'with
					 d as (select * from '+@tableName+' '+@where+')
					,a as (select isNull(convert(nvarchar,'+@columnName+'), ''(null)'') v, count(*) cnt from d group by '+@columnName+') 
					,b as (select row_number() over (order by cnt desc) ii, v, cnt from a)
				update c set c.'+@columnName+' = (convert(nvarchar,b.v) + ''  ('' + convert(nvarchar,cnt) + '')'') 
					from [{tempShowValues}] c 
						join b	 on c.ii = b.ii'		*/
 
		set @i += 1
	end
select * from [{tempShowValues}]
set noCount off
 
 end
 
 
 
