CREATE function cellarInformation(@bottleLocations varchar(max), @userComments varchar(max))
returns varchar(max)
as begin
	return isnull(@bottleLocations, '') + isnull(' [' + @userComments + ']', '')
end
