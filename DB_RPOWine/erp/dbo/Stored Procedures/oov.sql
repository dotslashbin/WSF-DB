-- shortcut	[=]
CREATE  procedure oov @1 varchar(99) = '', @2 varchar(99)=null
as begin 
	exec oo 'v', @1, @2
end
