
CREATE proc [dbo].[update2WineNamesChunk]
as 
begin
	set nocount on;
	/*
	*/
	declare	@date smallDatetime =getDate(),      
		@lock int,     
		@namerWhN int=dbo.constWhJb()
	
	/*
	with 
	 a as	(	select min(idN) idN,joinx from vjwine group by joinx     )
	,b as	(	select idN from a left join winename c on a.joinx=c.joinx where c.joinx is null     )
	select count(*) from b
	4667
	*/   
 
	begin transaction
	exec @lock = sp_getapplock @resource='addNewWine_insertIntoWineName', @lockmode='Exclusive'
	if @lock<0 begin
		rollback transaction
	end else begin
		set identity_insert wine on
		begin try;
				with 
				 a as	(	select min(idN) idN,joinx from vjwine group by joinx     )
				,b as	(	select idN from a left join winename c on a.joinx=c.joinx where c.joinx is null     )
				,d as	(	select e.* from vjwine e join b on e.idN=b.idN)
				insert into wineName (activeVinn, Producer, producerShow, labelName, colorClass, country, region, location, locale, site, variety, wineType, dryness, createDate,namerwhN, joinx
										, encodedKeywords, matchName     )
					select top 1000
										   case when vinn>0 then vinn else null end
										 , Producer, dbo.convertSurname(Producer), labelName, colorClass, country, region, location, locale, site, variety, wineType, dryness, @date, @namerWhN, joinx
										 , case when producer is null then '' else dbo.convertSurname(producer) + ' ' end
										 + case when labelName is null then '' else labelName + ' ' end
										 + case when dryness is null then '' else dryness + ' ' end
										 + case when colorClass is null then '' else colorClass + ' ' end
										 + case when wineType is null then '' else wineType + ' ' end
										 + case when variety is null then '' else variety + ' ' end
										 + case when country is null then '' else country + ' ' end
										 + case when region is null then '' else region + ' ' end
										 + case when location is null then '' else location + ' ' end
										 + case when locale is null then '' else locale + ' ' end
										 + case when site is null then '' else site + ' ' end
							, dbo.getMatchName(dbo.convertSurname(Producer),labelName,colorClass,variety,country,region,location,locale,site)
						from d
		end try 
		begin catch 
			--for now assume that the failures are because its already there
		end catch
		set identity_insert wine off

		exec sp_releaseAppLock @resource='addNewWine_insertIntoWineName'
		commit transaction
	end
end
 
 
 







