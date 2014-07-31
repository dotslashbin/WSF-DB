CREATE proc updateErpWineNameFromIn (@error varchar(max) = '' output) as begin
set nocount on;
/*
USE erpin
alter view vWineName as select * from erp..wineName
alter view vWine as select * from erp..wine
select * from vwinename


*/
 
declare @date date=getDate(), @lock int = -999999

------------------------------------------------------------------------------------------------------------------------------
-- Update matched records
------------------------------------------------------------------------------------------------------------------------------
begin transaction
exec @lock = sp_getapplock @resource='addNewWine', @lockmode='Exclusive'
if @lock<0
	begin
			rollback transaction
			set @error = 'updateErpWineNameFromIn:  Matched failed to get a lock'
			print @error
			return
	end
else
	begin
			merge vWineName a
				using wineName b
					on a.joinx = b.joinx
			when matched and
						(
							a.activeVinn <> b.activeVinn or (a.activeVinn is null and b.activeVinn is not null) or (a.activeVinn is not null and b.activeVinn is null)
							or a.colorClass <> b.colorClass or (a.colorClass is null and b.colorClass is not null) or (a.colorClass is not null and b.colorClass is null)
							or a.country <> b.country or (a.country is null and b.country is not null) or (a.country is not null and b.country is null)
							or a.createDate <> b.createDate or (a.createDate is null and b.createDate is not null) or (a.createDate is not null and b.createDate is null)
							or a.createWhN <> b.createWhN or (a.createWhN is null and b.createWhN is not null) or (a.createWhN is not null and b.createWhN is null)
							or a.dryness <> b.dryness or (a.dryness is null and b.dryness is not null) or (a.dryness is not null and b.dryness is null)
							or a.encodedKeyWords <> b.encodedKeyWords or (a.encodedKeyWords is null and b.encodedKeyWords is not null) or (a.encodedKeyWords is not null and b.encodedKeyWords is null)
							or a.isInactive <> b.isInactive or (a.isInactive is null and b.isInactive is not null) or (a.isInactive is not null and b.isInactive is null)
							or a.joinX <> b.joinX or (a.joinX is null and b.joinX is not null) or (a.joinX is not null and b.joinX is null)
							or a.labelName <> b.labelName or (a.labelName is null and b.labelName is not null) or (a.labelName is not null and b.labelName is null)
							or a.locale <> b.locale or (a.locale is null and b.locale is not null) or (a.locale is not null and b.locale is null)
							or a.location <> b.location or (a.location is null and b.location is not null) or (a.location is not null and b.location is null)
							or a.namerWhN <> b.namerWhN or (a.namerWhN is null and b.namerWhN is not null) or (a.namerWhN is not null and b.namerWhN is null)
							or a.places <> b.places or (a.places is null and b.places is not null) or (a.places is not null and b.places is null)
							or a.producer <> b.producer or (a.producer is null and b.producer is not null) or (a.producer is not null and b.producer is null)
							or a.producerProfileFile <> b.producerProfileFile or (a.producerProfileFile is null and b.producerProfileFile is not null) or (a.producerProfileFile is not null and b.producerProfileFile is null)
							or a.producerShow <> b.producerShow or (a.producerShow is null and b.producerShow is not null) or (a.producerShow is not null and b.producerShow is null)
							or a.producerURL <> b.producerURL or (a.producerURL is null and b.producerURL is not null) or (a.producerURL is not null and b.producerURL is null)
							or a.producerUrlN <> b.producerUrlN or (a.producerUrlN is null and b.producerUrlN is not null) or (a.producerUrlN is not null and b.producerUrlN is null)
							or a.region <> b.region or (a.region is null and b.region is not null) or (a.region is not null and b.region is null)
							or a.site <> b.site or (a.site is null and b.site is not null) or (a.site is not null and b.site is null)
							or a.updateWhN <> b.updateWhN or (a.updateWhN is null and b.updateWhN is not null) or (a.updateWhN is not null and b.updateWhN is null)
							or a.variety <> b.variety or (a.variety is null and b.variety is not null) or (a.variety is not null and b.variety is null)
							or a.wineType <> b.wineType or (a.wineType is null and b.wineType is not null) or (a.wineType is not null and b.wineType is null)
						)
						  then
								update set 
										activeVinn=b.activeVinn
										, colorClass=b.colorClass
										, country=b.country
										, createDate=b.createDate
										, createWhN=b.createWhN
										, dryness=b.dryness
										, encodedKeyWords=b.encodedKeyWords
										, isInactive=b.isInactive
										, joinX=b.joinX
										, labelName=b.labelName
										, locale=b.locale
										, location=b.location
										, namerWhN=b.namerWhN
										, places=b.places
										, producer=b.producer
										, producerProfileFile=b.producerProfileFile
										, producerShow=b.producerShow
										, producerURL=b.producerURL
										, producerUrlN=b.producerUrlN
										, region=b.region
										, site=b.site
										, updateWhN=b.updateWhN
										, variety=b.variety
										, wineType=b.wineType;
			print 'updateErpWineNameFromIn - Matched: ' + convert(nvarchar, @@rowCount)

			exec sp_releaseAppLock @resource='addNewWine'
			commit transaction
	end 


------------------------------------------------------------------------------------------------------------------------------
-- Insert unmatched records
------------------------------------------------------------------------------------------------------------------------------
begin transaction
exec @lock = sp_getapplock @resource='addNewWine', @lockmode='Exclusive'
if @lock<0
	begin
			rollback transaction
			set @error = 'updateErpWineNameFromIn:  Not Matched failed to get a lock'
			print @error
			return
	end
else
	begin
			merge vWineName a
				using wineName b
					on a.joinx = b.joinx
			when not matched by target then
				insert	(
							  activeVinn
							, colorClass
							, country
							, createDate
							, createWhN
							, dryness
							, encodedKeyWords
							, isInactive
							, joinX
							, labelName
							, locale
							, location
							, namerWhN
							, places
							, producer
							, producerProfileFile
							, producerShow
							, producerURL
							, producerUrlN
							, region
							, site
							, updateWhN
							, variety
							, wineType
						)
					values		
						(
							  activeVinn
							, colorClass
							, country
							, createDate
							, createWhN
							, dryness
							, encodedKeyWords
							, isInactive
							, joinX
							, labelName
							, locale
							, location
							, namerWhN
							, places
							, producer
							, producerProfileFile
							, producerShow
							, producerURL
							, producerUrlN
							, region
							, site
							, updateWhN
							, variety
							, wineType
						)
			when not matched by source and a.dateHi is null then
				update set 
					dateHi=@date;
			print 'updateErpWineNameFromIn - Not Matched: ' + convert(nvarchar, @@rowCount)
					
			exec sp_releaseAppLock @resource='addNewWine'
			commit transaction
	end 





update a set a.dateHi=null
	from vWineName a
		join (select distinct wineNameN from vWine) b
			on a.wineNameN=b.wineNameN
	where a.dateHi is not null;
print 'dateHi nulled: ' + convert(nvarchar, @@rowCount)	
												
													



 
end
