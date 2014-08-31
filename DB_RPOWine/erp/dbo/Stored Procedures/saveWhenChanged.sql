create proc saveWhenChanged
as begin
	if not exists (select name from master..sysobjects where xtype='u' and name = 'whenChanged')
		begin
			select * into master..whenChanged from vWhenChanged
		end
	else
		begin
			merge master..whenChanged as a
				using vWhenChanged b
					on a.database_id=b.database_id and a.object_id=b.object_id
			when matched and b.updateDate is not null and b.updateDate > a.updateDate then
				update set a.updateDate = b.updateDate
			when not matched by target then
				insert(database_id, object_id, updateDate)
					values(b.database_id, b.object_id, b.updateDate);
		end
end

