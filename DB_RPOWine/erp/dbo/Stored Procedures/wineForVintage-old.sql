CREATE proc [wineForVintage-old] (@existingWineN int, @vintage nvarchar(5), @newWineN int output)

as begin

 

declare @activeVinn int = null, @vintageAsOffset int = 0, @v int

 

set @vintage = case when @vintage like '%N%V%' then 'NV' else @vintage end;

 

if @vintage like '%[0-9][0-9][0-9][0-9]%'

            begin

                        set @v = cast(@vintage as int)

                        if @v between 1501 and 2499                        --1500 is reserved for NV

                                    set @vintageAsOffset = @v - 1500

                        else

                                    return

            end

else 

            begin

                        if @vintage like '%N%V%'

                                    select @vintage = 'NV', @vintageAsOffset = 0

                        else

                                    return

            end

  

select top 1 @activeVinn = activeVinn

            from wine where wineN = @existingWineN order by wineN

 

if @activeVinn is not null

            begin

                        select top 1 @newWineN = wineN

                                    from wine where activeVinn = @activeVinn and vintage = @vintage order by wineN

            end

                        

if @newWineN is null and @activeVinn is not null

            begin

                        -- make sure min effective activeVinn is 1000000

                        set @newWineN = (@activeVinn + 1000000)  * 1000 + @vintageAsOffset

                        if not exists (select * from wine where wineN = @newWineN)

                                    begin

                                                set identity_insert wine on

                                                insert into

                                                            wine (wineN, activeVinn, wineNameN, vintage, createDate, encodedKeywords)

                                                            select top 1

                                                                                       @newWineN

                                                                                     , @activeVinn

                                                                                     , b.wineNameN

                                                                                     , @vintage

                                                                                     , getDate()

                                                                                     , @vintage + ' ' + b.encodedKeywords

                                                                        from

                                                                                    wine a join wineName b

                                                                                                on a.wineNameN = b.wineNameN

                                                                        where

                                                                                    a.wineN = @existingWineN

                                                            set identity_insert wine off

                                    end

            end

end

 

 


