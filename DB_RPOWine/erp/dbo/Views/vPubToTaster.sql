CREATE view vPubToTaster as
	select pubGN, pubN, tasterN, pubG, pub, dbo.getName(tasterN) taster
		from vPubNeedingTasters a
			join whToTaster b
				on b.whN = a.pubN
