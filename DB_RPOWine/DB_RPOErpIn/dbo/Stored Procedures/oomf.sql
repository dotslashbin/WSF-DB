CREATE  procedure [dbo].[oomf] @1 varchar(99) = '', @2 varchar(99)=null
as begin 
	exec oo FM, @1, @2
end
