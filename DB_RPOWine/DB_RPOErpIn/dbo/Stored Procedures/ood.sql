CREATE  procedure [dbo].[ood] @1 varchar(99) = '', @2 varchar(99)=null
as begin 
	exec oo 'D', @1, @2
end
