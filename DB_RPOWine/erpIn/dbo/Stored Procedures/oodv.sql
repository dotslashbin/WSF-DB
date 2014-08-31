create  procedure [dbo].[oodv] @1 varchar(99) = '', @2 varchar(99)=null
as begin 
	exec oo 'DV', @1, @2
end
