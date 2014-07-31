-- shortcut		[=]
CREATE  procedure oon @1 varchar(99) = '', @2 varchar(99)=null
as begin 
	exec oo 'N', @1, @2
end
