create  procedure [dbo].[ootd] @1 varchar(99) = '', @2 varchar(99)=null
as begin 
	exec oo 'DT', @1, @2
end