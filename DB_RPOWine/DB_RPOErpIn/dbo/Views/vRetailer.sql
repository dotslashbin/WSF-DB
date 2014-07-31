CREATE view vRetailer as
	select     
	[Retailer-Code] retailerCode
	,retailerN,[Retailer-Name] retailerName
		,Address,City,State,Zip,Country,[Ship-to-Country] shipToCountry,Phone,Fax,Email,URL,errors,warnings
	from waRetailerTable
