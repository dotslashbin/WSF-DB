CREATE AGGREGATE [dbo].[Concatenate](@input NVARCHAR (200))
    RETURNS NVARCHAR (MAX)
    EXTERNAL NAME [Hello1Cls1].[Concatenate];

