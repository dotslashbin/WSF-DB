create view vWhenChanged as
	select database_id, object_id, max(last_user_update) updateDate
		from sys.dm_db_index_usage_stats
		group by database_id, object_id
