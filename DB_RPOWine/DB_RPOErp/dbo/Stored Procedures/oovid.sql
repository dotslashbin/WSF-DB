-- shortcut	[=]
CREATE  procedure oovid @1 varchar(99) = '', @2 varchar(99)=null
as begin 
	exec oo 'DIv', @1, @2
end
