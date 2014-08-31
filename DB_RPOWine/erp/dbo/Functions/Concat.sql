CREATE AGGREGATE [dbo].[Concat](@input NVARCHAR (200))
    RETURNS NVARCHAR (MAX)
    EXTERNAL NAME [wineMaint1].[Concat];

