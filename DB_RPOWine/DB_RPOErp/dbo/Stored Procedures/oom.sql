﻿-- shortcut		[=]
CREATE  procedure oom @1 varchar(99) = '', @2 varchar(99)=null
as begin 
	exec oo 'M', @1, @2
end
 
