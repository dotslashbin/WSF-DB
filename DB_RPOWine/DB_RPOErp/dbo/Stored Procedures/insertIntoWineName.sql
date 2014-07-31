CREATE proc [dbo].insertIntoWineName(
	@activeVinn int=null
	, @producer nvarchar(100)
	, @labelName nvarchar(150)
	, @colorClass nvarchar(20)
	, @variety nvarchar(100)
	, @dryness nvarchar(500)
	, @wineType nvarchar(500)
	, @country nvarchar(100)
	, @region nvarchar(100)
	, @location nvarchar(100)
	, @locale nvarchar(100)
	, @site nvarchar(100)
	, @namerWhN nvarchar(4)
	, @joinX varchar(max)
	, @wineNameN int output     )
as begin
 
declare @lock int
begin transaction
exec @lock = sp_getapplock @resource='addNewWine_insertIntoWineName', @lockmode='Exclusive'
if @lock<0
	begin
			rollback transaction
			RAISERROR (N'myWines/insertIntoWineName Lock Timeout',16,1)
	end
else
	begin
		begin try
			exec insertIntoWineNameLocked 	
				  @activeVinn
				, @producer
				, @labelName
				, @colorClass
				, @variety
				, @dryness
				, @wineType
				, @country
				, @region
				, @location
				, @locale
				, @site
				, @namerWhN
				, @joinX
				, @wineNameN =@wineNameN output
 
			exec sp_releaseAppLock @resource='addNewWine_insertIntoWineName'
			commit transaction
		end try
		begin catch
			exec sp_releaseAppLock @resource='addNewWine_insertIntoWineName'
			declare @s nvarchar(max)='MyWines/'+ERROR_Procedure()+': '+ERROR_MESSAGE()+' (line '+convert(nvarchar, ERROR_LINE())+')'
			rollback transaction
			RAISERROR (@s,16,1)
			end catch
	end 
 
end
 
 
 
 
 
 
 
 
 
 
