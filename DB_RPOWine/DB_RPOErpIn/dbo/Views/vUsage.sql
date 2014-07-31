create view vUsage as 
	select idN, wid, vinN, wineN
		, wineNameN 
		, vintage
		, dbo.fmtd(dateLo)dateLo
		, dbo.fmtd(dateHi)dateHi, isLive
		, isWineNameVinnSource isVinn
		, isPriorWineNameVinnSource isPrior
	from idUsage
