CREATE  procedure [dbo].[oodit] @1 varchar(99) = '', @2 varchar(99)=null
as begin 
	exec oo 'DIT', @1, @2
end
