CREATE  procedure [dbo].[oofd] @1 varchar(99) = '', @2 varchar(99)=null
as begin 
	exec oo 'DF', @1, @2
end
