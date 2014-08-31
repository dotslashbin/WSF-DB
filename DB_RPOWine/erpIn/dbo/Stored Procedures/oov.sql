-- shortcut		[=]
CREATE  procedure [dbo].[oov] @1 varchar(99) = '', @2 varchar(99)=null
as begin 
	exec oo 'V', @1, @2
end
 
