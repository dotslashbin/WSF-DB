-- icons utility [=]
CREATE  procedure [dbo].[ooicons] 
as begin 
	select * from icon order by displayName, tag
end
