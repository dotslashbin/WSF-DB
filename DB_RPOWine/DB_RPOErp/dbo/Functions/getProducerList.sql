	CREATE function [dbo].[getProducerList] (@keywords varchar(200), @country varChar(200), @region varChar(200), @location varChar(200), @subLocation varChar(200), @detailedLocation varChar(200))
	/*
	use erpTiny
	set statistics time off
	select * from getProducerList('a', null, 'north coast', null, null, null)
	select * from getProducerList('a', null, '', null, null, null)
	updateMasterTables
	select * from getProducerList('qq', null, '', null, null, null)
	select * from dbo.getProducerlist2('','','','','','')
	select * from dbo.getProducerlist2('tar','','','','','')
	 
	 */
	returns @R table(producerShow varChar(200), producer varChar(200))
	as begin
		select
			  @keywords=ltrim(rtrim(@keywords))
			, @country=ltrim(rtrim(@country))
			, @region=ltrim(rtrim(@region))
			, @location=ltrim(rtrim(@location))
			, @subLocation=ltrim(rtrim(@subLocation))
			, @detailedLocation=ltrim(rtrim(@detailedLocation))
	 
		select
			@country=case when @country<>'' then @country else null end
			, @region=case when @region<>'' then @region else null end
			, @location=case when @location<>'' then @location else null end
			, @subLocation=case when @subLocation<>'' then @subLocation else null end
			, @detailedLocation=case when @detailedLocation<>'' then @detailedLocation else null end
	 
		declare @contains nvarchar(900)=null
		declare @T table(producerShow varChar(200), producer varChar(200))
		
		set @contains=dbo.buildSQLContains(@keywords)
	 
		if @contains is null
			insert into @T(producerShow, producer)
				select top 100 producerShow, producer
					from masterLocProducer
					where 
						len(producerShow)>0
						and (@country is Null or country=@country)
						and (@region is Null or region=@region)
						and (@location is Null or location=@location)
						and (@subLocation is Null or subLocation=@subLocation)
						and (@detailedLocation is Null or detailedLocation=@detailedLocation)
					order by producer, producerShow
		else
			insert into @T(producerShow, producer)
				select top 100 producerShow, producer
					from masterLocProducer
					where 
						len(producerShow)>0
						and contains(producerShow, @contains)
						and (@country is Null or country=@country)
						and (@region is Null or region=@region)
						and (@location is Null or location=@location)
						and (@subLocation is Null or subLocation=@subLocation)
						and (@detailedLocation is Null or detailedLocation=@detailedLocation)
					order by producer, producerShow
		 
		IF EXISTS(SELECT * FROM @T)
			BEGIN
				insert into @R(producerShow, producer)
					select top 100 producerShow, producer
						from @T
						group by producerShow, producer
						order by producer, producerShow
			END
		ELSE
			BEGIN
				DECLARE @loc NVARCHAR(200)=null
				SET @loc =	CASE 
								WHEN  @detailedLocation IS NOT NULL THEN @detailedLocation
								WHEN @subLocation IS NOT NULL THEN @subLocation
								WHEN @location IS NOT NULL THEN @Location
								WHEN @region IS NOT NULL THEN @region
								WHEN @country IS NOT NULL THEN @country
								ELSE NULL
								END
					IF @loc IS NULL
						INSERT INTO @R(producerShow) SELECT '(No matches)'
					ELSE
						INSERT INTO @R(producerShow) SELECT '(No matches in '+@loc+')'
			END
		
	return 
	end
	 
	 
	 
	 
	 
	 
	 
	 
	 
	 
