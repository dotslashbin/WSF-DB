CREATE proc wineForVintage_after1002Feb08 (@existingWineN int, @vintage nvarchar(5), @newWineN int output)
/*
select wineNameN, count (distinct vintage) cnt from wine group by wineNameN order by cnt desc
	wineNameN	cnt
	89235	104
	63598	92
	70569	90
	64134	84
	59450	78
	67073	66
	73856	66
	69080	64
	47255	64
	
select * from wineName where wineNameN in (89235, 63598, 70569, 64134, 59450, 67073, 73856, 69080, 47255)

wineNameN	activeVinn	namerWhN	producer	producerProfileFile	producerShow	producerURL	labelName	colorClass	variety	dryness	wineType	country	locale	location	region	site	places	encodedKeyWords	dateLo	dateHi	vintageLo	vintageHi	wineCount	joinX	createDate	createWhN	updateWhN	rowversion	isInactive	producerUrlN
64134	11791	-1	Latour	NULL	Latour	NULL	NULL	Red	Bordeaux Blend	Dry	Table	France	NULL	Pauillac	Bordeaux	NULL	NULL	Latour Red  Bordeaux Blend France Bordeaux Pauillac  Dry Table 	1992-04-23 00:00:00	2008-05-24 00:00:00	1863	2007	208       	Latour||Red|France|Bordeaux|Pauillac|||Bordeaux Blend|Table|Dry	2008-05-19 09:50:00	NULL	NULL	0x0000000002706E8F	0	180

select distinct (vintage) from wine where wineNameN=64134
	1900
	1909
	
select wineN, vintage from wine  where wineNameN=64134 and vintage in ('1900', '1909')
	wineN	vintage
	27823	1900
	59962	1909


1901=>	1011791401
		1011791401
1902=>	1011791402

declare @wineNN int, @wineNN2 int, @wineNN3 int, @jj int
exec dbo.wineForVintage_after1002Feb08 27823, '1900', @newWineN = @winenn output
print @wineNN
exec dbo.wineForVintage_after1002Feb08 27823, '1901', @newWineN = @winenn2 output
print @wineNN2
exec dbo.wineForVintage_after1002Feb08 27823, '1902', @newWineN = @winenn3 output
print @wineNN3
	27823
	1011791401
	1011791402

declare @wineNN int, @wineNN2 int, @wineNN3 int, @jj int
exec dbo.wineForVintage_after1002Feb08 1011791402, '1900', @newWineN = @winenn output
print @wineNN
exec dbo.wineForVintage_after1002Feb08 1011791402, '1901', @newWineN = @winenn2 output
print @wineNN2
exec dbo.wineForVintage_after1002Feb08 1011791402, '1902', @newWineN = @winenn3 output
print @wineNN3

*/ 
 as begin
-- declare @existingWineN int=1011791401, @vintage nvarchar(5) = '1902', @newWineN int= null
 
declare @activeVinn int = null, @vintageAsOffset int = 0, @v int;
declare @minEffectiveVinn int = 1000000;
  
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

		if @newWineN is null and @activeVinn between 0 and @minEffectiveVinn
			begin
				set @activeVinn += @minEffectiveVinn
				select top 1 @newWineN = wineN
                                     from wine where activeVinn = @activeVinn and vintage = @vintage order by wineN
			end
		else if @newWineN is null and @activeVinn > @minEffectiveVinn
			begin
				select top 1 @newWineN = wineN
                                     from wine where activeVinn = (@activeVinn - @minEffectiveVinn)  and vintage = @vintage order by wineN
			end


             end
                         
if @newWineN is null and @activeVinn is not null
             begin
                         if @activeVinn < 0 
                                     begin
                                                 --kludge to handle -Vinns which only occur in the old database
                                                 select @newWineN = (MIN(wineN) - 1) from wine
                                     end
                         else
                                     begin
                                                 -- make sure min effective activeVinn is @minEffectiveVinn
                                                --set @newWineN = (@activeVinn + @minEffectiveVinn)  * 1000 + @vintageAsOffset
                                                set @newWineN = (@activeVinn  * 1000) + @vintageAsOffset 
                                     end
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
--select @newWineN
 end
 
 
