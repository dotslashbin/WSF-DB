CREATE AGGREGATE [dbo].[concatFF](@input NVARCHAR (200))
    RETURNS NVARCHAR (MAX)
    EXTERNAL NAME [myWinesClr].[concatFF];

