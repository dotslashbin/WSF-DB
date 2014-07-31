create  procedure oo
	 @1 varchar(99) = ''
	,@2 varchar(99)=null
	,@3 varchar(99)=null
as begin
	select * from ooFun (@2, @3, @1) 
end
