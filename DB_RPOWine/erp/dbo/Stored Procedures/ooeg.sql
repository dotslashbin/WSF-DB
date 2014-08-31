create  procedure ooeg @1 varchar(99) = '', @2 varchar(99)=null
as begin 
	exec oo 'EG', @1, @2
end
