﻿CREATE  procedure [dbo].[oofdr] @1 varchar(99) = '', @2 varchar(99)=null
as begin 
	exec oo 'DFR', @1, @2
end
