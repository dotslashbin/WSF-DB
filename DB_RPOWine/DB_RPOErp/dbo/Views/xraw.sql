
CREATE view xraw as
	select vintage Xvintage,producer Xproducer,labelname Xlabelname,variety Xvariety,colorClass XcolorClass,winetype Xwinetype,dryness Xdryness,country Xcountry,region Xregion,location Xlocation,locale Xlocale,site Xsite,wineN XwineN,vinn Xvinn,fixedid Xfixedid
		from JRulesRaw
