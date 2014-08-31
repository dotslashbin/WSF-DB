--utility		[=]
CREATE procedure  z_allCol
	  @1 varchar(99)
	, @1alias varchar(99) = ''
	, @2 varchar(99) = ''
	, @2alias varchar(99) = ''
	, @2suffix varchar(99) = ''
as begin
	set nocount on;
	print dbo.allColFun(@1, @1alias, @2, @2alias, @2suffix)
end
