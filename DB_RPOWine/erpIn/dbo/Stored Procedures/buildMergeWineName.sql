--use erpin		
------------------------------------------------------------------------------------------
-- Program fields for merge
------------------------------------------------------------------------------------------
CREATE proc buildMergeWineName (@table varchar(max), @excludedFields varchar(max))
as begin
	set @excludedFields = ' ' + @excludedFields + ' '
	select replace('or a.$ <> b.$ or (a.$ is null and b.$ is not null) or (a.$ is not null and b.$ is null)', '$', column_name) 
		from information_schema.columns 
			where table_name = @table and @excludedFields not like ('% ' + column_name + ' %')
			order by column_name
	select replace(', $=b.$', '$', column_name) 
		from information_schema.columns 
			where table_name = @table and @excludedFields not like ('% ' + column_name + ' %')
			order by column_name
	select replace(', $', '$', column_name) 
		from information_schema.columns 
			where table_name = @table and @excludedFields not like ('% ' + column_name + ' %')
			order by column_name
	
/*
declare @date date=getDate()
merge vWineName a
	using wineName b
		on a.joinx = b.joinx
when matched then
		and	(     
					or a.$ <> b.$ or (a.$ is null and b.$ is not null) or (a.$ is not null and b.$ is null)
				)
			  then
	update set 
		, $=b.$ 
when not matched by target then
	insert	(
			, $
			)
		values		
			(
			, $
			)				
when not matched by source ) then
	update set 
		dateHi=@date
*/	
end
/*
buildMerge tasting, 'tastingN rowversion timeStamp _fixedId _fixedIdDeleted foo'
*/
 
 
