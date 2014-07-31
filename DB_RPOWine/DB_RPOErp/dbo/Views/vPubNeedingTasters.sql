create view vPubNeedingTasters as 
	select pubGN, pubN, dbo.getName(pubGN) pubG, dbo.getName(pubN) pub
			from pubGToPub a
				join wh b
					on b.whN = a.pubN
				where 
					b.isTasterAsPub = 1
