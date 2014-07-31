CREATE  procedure oort @1 varchar(99) = '', @2 varchar(99)=null
as begin 
	exec oo 'RT', @1, @2
end