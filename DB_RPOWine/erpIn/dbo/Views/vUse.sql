create view vUse as 
	select idN, wid, vinN, wineN
		, wineNameN 
		, vintage
		, dbo.fmtd(dateLo)dateLo
		, dbo.fmtd(dateHi)dateHi, isLive
		, isWineNameVS isVS
		, isPriorWineNameVS isPriorVS
		, dbo.fmt(VSFirstDate) VSFirst
		, dbo.fmt(VSActiveDate) VSActive
		, dbo.fmt(VSLastDate) VSLast
	from idUse
