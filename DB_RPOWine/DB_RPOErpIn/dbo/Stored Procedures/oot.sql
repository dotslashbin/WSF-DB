CREATE  procedure [dbo].[oot] @1 varchar(99) = '', @2 varchar(99)=null
as begin 
	exec oo 'T', @1, @2
end
