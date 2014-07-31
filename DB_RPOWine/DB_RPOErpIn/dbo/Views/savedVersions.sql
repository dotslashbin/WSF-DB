create view savedVersions as
                        select saveName, max(rowVersion) mru 
                                                from (
                                                            select tasterN whN, saveName, [rowVersion] from savedTables..tasting
                                                            union
                                                            select whN, saveName, [rowVersion] from savedTables..whToWine
                                                            union
                                                            select whN, saveName, [rowVersion] from savedTables..BottleLocation
                                                            union
                                                            select whN, saveName, [rowVersion] from savedTables..Location
                                                            union
                                                            select whN, saveName, [rowVersion] from savedTables..Purchase
                                                            union
                                                            select whN, saveName, [rowVersion] from savedTables..Supplier
                                                ) a
                                                group by whN, saveName
--
