CREATE view [vname] as
	select wineNameN
			, joinX
			, isLive live
			, activeVinn vinn
			,isNewAdtiveVinnNotYetApproved notOked
			, dbo.fmtd(dateLo)dateLo
			, dbo.fmtd(dateHi)dateHi
			, vintageLo
			, vintageHi
			, wineCount[#wines]
			, dbo.fmtd(createDate)created
		from wineName
