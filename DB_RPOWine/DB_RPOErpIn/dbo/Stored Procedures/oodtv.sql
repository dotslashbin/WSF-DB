create  procedure [dbo].[oodtv] @1 varchar(99) = '', @2 varchar(99)=null
as begin 
	exec oo 'DTV', @1, @2
end
