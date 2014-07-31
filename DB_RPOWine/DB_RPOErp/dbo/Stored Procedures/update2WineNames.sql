CREATE proc [dbo].[update2WineNames]
as 
begin
	exec dbo.ooLog 'update2WineNames begin';
	set nocount on;
	declare @cnt int
	--while 1=1
	while exists(select * from vjwine a where not exists(select * from winename b where a.joinx=b.joinx))
		begin
		
			select @cnt=count(*) 
			from (
				select distinct joinx from vjwine 
					except select distinct joinx joinx 
					from winename
					)a
					
			if @cnt=0 break
		
			exec dbo.update2wineNamesChunk
			
			exec dbo.ooLog '     1000 of @1 done', @cnt
		end
	 
	-----------------------------------------------------------------------------------
	-- Update Namer
	----------------------------------------------------------------------------------
	 
	exec dbo.ooLog 'update2WineNames end';
end
 
