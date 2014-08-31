--dwff keep
CREATE view [dbo].[vFastPubGToTasting] with schemabinding as
	select z.pubGN, tastingN,wineN,vinN,wineNameN,z.pubN,tasterN
		from dbo.pubGToPub z
			join dbo.tasting y
				on z.pubN = y.pubN
 
