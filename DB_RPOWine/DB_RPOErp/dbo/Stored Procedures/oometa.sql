CREATE  procedure oometa @1 varchar(99) = ''
as begin 
	select * from ooMetaFun(@1)
end
