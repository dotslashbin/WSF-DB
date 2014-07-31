CREATE  procedure [dbo].[oomi] @1 varchar(99) = '', @2 varchar(99)=null
as begin 
	exec oo IM, @1, @2
end