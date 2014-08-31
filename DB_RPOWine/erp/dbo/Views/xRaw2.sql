
CREATE view xRaw2 as
	select xWineN,wineN,vinn,xvintage, Vintage, dbo.convertSurname(Xproducer)XProducerShow, dbo.convertSurname(producer)ProducerShow, producer, Xlabelname, LabelName
				,Xvariety,variety,XcolorClass,colorClass,Xwinetype,winetype,Xdryness,dryness
				,Xcountry, Country,Xregion,Region,Xlocation,location,Xlocale,Locale,Xsite,Site
		from xraw a
			join JRulesWine on Xfixedid=FixedId
