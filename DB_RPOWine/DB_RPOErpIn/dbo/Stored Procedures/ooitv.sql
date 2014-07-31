-- shortcut	[=]
CREATE  procedure [dbo].[ooitv] @1 varchar(99) = '', @2 varchar(99)=null
as begin 
	exec oo 'ITV', @1, @2
end
