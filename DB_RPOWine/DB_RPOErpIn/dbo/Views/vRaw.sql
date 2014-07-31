CREATE view vRaw as 
	(select
		--idn
		wineN
		,vinN
		,wid
		,producer
		,producerShow
		,labelName
		,vintage
		,country
		,region
		,location
		,locale
		,site
		,variety
		,colorClass
		,dryness
		,wineType
		--,dateCreated
		--,dateUpdated
		,whoUpdated
		,fixedId
		--,phase
	from nameYearRaw
)
