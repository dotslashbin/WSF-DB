
CREATE proc wineForVintage (@existingWineN int, @vintage nvarchar(5), @newWineN int output) as begin
exec dbo.wineForVintageVinn @existingWineN, null, null, @vintage, @newWineN=@newWineN output
 end
 
 
 
 

















