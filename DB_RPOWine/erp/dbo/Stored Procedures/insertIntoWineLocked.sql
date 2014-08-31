
CREATE proc [dbo].insertIntoWineLocked (@newWineN int, @activeVinn int, @wineNameN int , @vintage nvarchar(5))
as begin
if not exists (select *from wine where wineN=@newWineN)
	begin
		set identity_insert wine on
		 insert into
			 wine (wineN, activeVinn, wineNameN, vintage, createDate, encodedKeywords)
			 select top 1
					  @newWineN
					, @activeVinn
					, @wineNameN
					, @vintage
					, getDate()
					, @vintage + ' ' + encodedKeywords
				from wineName
				where	wineNameN=@wineNameN 
		set identity_insert wine off
	end
end
            
 
 







