--use erpin		
------------------------------------------------------------------------------------------
-- Program fields for merge
------------------------------------------------------------------------------------------
CREATE proc buildMerge (@table varchar(max), @excludedFields varchar(max))
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
buildMergeTasting 'tasting', 'tastingN rowversion'

declare @date date=getDate()
merge vWine a
	using vTasting b
		on a.wineN = b.wineN
when matched 
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
when not matched by source )
		and dataSourceN is not null 
			and dataSourceN in (select dataSourceN from @TSources)
			and dataIdN is not null 
			and (dataIdnDeleted is null or dataIdnDeleted <> 1) then
		update set 
			a.dataIdnDeleted = 1;			    
*/	
end
/*
buildMerge tasting, 'tastingN rowversion timeStamp _fixedId _fixedIdDeleted foo'
*/
 
 
