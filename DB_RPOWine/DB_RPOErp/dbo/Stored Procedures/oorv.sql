CREATE  procedure oorv @1 varchar(99) = '', @2 varchar(99)=null
as begin 
	exec oo 'vr', @1, @2
end
