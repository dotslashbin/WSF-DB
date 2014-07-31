CREATE  procedure [dbo].[oor] @1 varchar(99) = '', @2 varchar(99)=null
as begin 
	exec oo R, @1, @2
end