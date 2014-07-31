CREATE proc [dbo].updateWinenameInfo
 as begin
exec dbo.oolog 'updateWinenameInfo begin'; 

update winename set matchName=dbo.getMatchName(dbo.convertSurname(Producer),labelName,colorClass,variety,country,region,location,locale,site)
	where matchName is null
 
exec dbo.updateMasterTableLocProducer null
			--RECALC--or a.encodedKeywords<>b.encodedKeywords or ( a.encodedKeywords is null and b.encodedKeywords is not null) or (a.encodedKeywords is not null and b.encodedKeywords is null)
			--RECALC--or a.hasErpTasting<>b.hasErpTasting or ( a.hasErpTasting is null and b.hasErpTasting is not null) or (a.hasErpTasting is not null and b.hasErpTasting is null)

exec dbo.oolog 'updateWinenameInfo end'; 
end
 
