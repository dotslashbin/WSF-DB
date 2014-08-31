create proc [fixup_oldSep4-2009] as Begin         

 

exec dbo.calcWhToWineAll;

 

with

a as (select 

                                                  *

                                                , (select SUM(ISNULL(bottleCount, 0)) x from erpCellar..purchase where whN = whToWine.whN and wineN = whToWine.wineN) bottleCountCalc  

                                                , (select COUNT(*) from tasting where tasterN = whToWine.whN and wineN = whToWine.wineN) tastingCountCalc

                                    from whToWine

                        )

update a set 

                                                  bottleCount = case when bottleCountCalc > 0 then bottleCountCalc else isNull(bottleCount, 0) end

                                                , tastingCount = case when tastingCountCalc > 0 then tastingCountCalc else isNull(tastingCount, 0) end

End

