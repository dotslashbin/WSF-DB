
CREATE proc [dbo].wineForVintageVinnLocked (@existingWineN int, @activeVinn int=null, @wineNameN int, @vintage nvarchar(5), @newWineN int output)
 as begin
-- declare @existingWineN int=27823, @vintage nvarchar(5) = '1901', @newWineN int= null
declare @vintageAsOffset int = 0, @v int, @producer nvarchar(200), @labelName nvarchar(200)
declare @maxVinn int = 2000000, @vinnTimes int = 1000, @vinnPlus int = 100000000
  
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
   
if @activeVinn is null 
	 select top 1 @activeVinn = activeVinn
			 from wine where wineN = @existingWineN order by wineN
	  
 if @activeVinn is not null
             begin
                  if @wineNameN is null
				select @wineNameN=wineNameN from wine  where wineN=@existingWineN 
                                                
			select @producer=producer, @labelName=labelName from wineName where wineNameN=@wineNameN
 
                   select top 1 @newWineN = wineN
                               from wine a
						join wineName b on a.wineNameN=b.wineNameN
					 where a.activeVinn = @activeVinn and vintage = @vintage and producer=@producer and ((labelName=@labelName ) or (labelName is null and @labelName is null))
					 order by wineN
 
			if @newWineN is null
				 begin
					 if @activeVinn < 0 											 
						 begin select @newWineN = (MIN(wineN) - 1) from wine end     --kludge to handle -Vinns which only occur in the old database
					 else
						 begin
								--set @newWineN = (@activeVinn  * @vinnTimes) + @vinnPlus + @vintageAsOffset 
								set @newWineN = dbo.findFreeWineN(@activeVinn, @vintageAsOffset)
						 end
 
						exec dbo.insertIntoWine @newWineN,@activeVinn, @wineNameN, @vintage
				 end
             end
                         
             
--select @newWineN
 end
 
/*
declare @wineNN int, @wineNN2 int, @wineNN3 int
exec dbo.wineForVintage 27823, '1900', @newWineN = @winenn output
print @wineNN
*/ 
 
 
 
 
 
 
 

