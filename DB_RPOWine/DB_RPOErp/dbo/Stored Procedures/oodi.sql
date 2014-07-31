create  procedure oodi @1 varchar(99) = '', @2 varchar(99)=null
as begin 
	exec oo 'DI', @1, @2
end
