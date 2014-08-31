CREATE proc [dbo].[oou] as begin
select object_name(object_id), * from sys.dm_db_index_usage_stats order by last_user_update desc
end
