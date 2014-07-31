-- utility [=]
CREATE function isEq (@a nvarchar(max), @b nvarchar(max))
returns bit
as begin

if @a is null begin
	if @b is null return 1
	end
else begin
	if @b is not null
		return case when @a = @b then 1 else 0 end
	end
return 0
end