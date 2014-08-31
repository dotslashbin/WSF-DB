CREATE proc [dbo].addWine2 (
 	   @delayMasterlistUpdate bit=0
	 , @forceWineN int=null
	, @forceVinn int=null
	, @vintage varchar(4) 
	, @producer nvarchar(100)
	, @labelName nvarchar(150)
	, @colorClass nvarchar(20)
	, @variety nvarchar(100)
	, @dryness nvarchar(500)
	, @wineType nvarchar(500)
	, @country nvarchar(100)
	, @locale nvarchar(100)
	, @location nvarchar(100)
	, @region nvarchar(100)
	, @site nvarchar(100)
	, @comments nvarchar(max)
	, @namerWhN int
	, @wineN int output
	)
as begin
declare @lock int
begin transaction
exec @lock = sp_getapplock @resource='addNewWine', @lockmode='Exclusive'
if @lock<0
	begin
			rollback transaction
			RAISERROR (N'myWines/addWine2 Lock Timeout',16,1)
	end
else
	begin
		begin try
			exec addWine2Locked 
 				   @delayMasterlistUpdate
				 , @forceWineN
				, @forceVinn 
				, @vintage 
				, @producer
				, @labelName
				, @colorClass
				, @variety
				, @dryness
				, @wineType
				, @country
				, @locale
				, @location
				, @region
				, @site
				, @comments
				, @namerWhN
				, @wineN=@wineN output
			exec sp_releaseAppLock @resource='addNewWine'
			commit transaction
		end try
		begin catch
			exec sp_releaseAppLock @resource='addNewWine'
			declare @s nvarchar(max)='MyWines/'+ERROR_Procedure()+': '+ERROR_MESSAGE()+' (line '+convert(nvarchar, ERROR_LINE())+')'
			rollback transaction
			RAISERROR (@s,16,1)
			end catch
	end 
end
 
 
 
 
 
 
 
 
 
 
 
 
