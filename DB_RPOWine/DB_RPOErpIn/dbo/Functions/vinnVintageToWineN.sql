create function vinnVintageToWineN(@vinn int, @vintage varchar(4))
returns int
as begin
declare @vinnTimes int = 1000, @vinnPlus int = 100000000,@date smallDateTime = getDate();
return (@vinn * @vinnTimes + @vinnPlus + case when 1=isNumeric(@vintage) then cast(@vintage as int) - 1500 else 0 end)

end