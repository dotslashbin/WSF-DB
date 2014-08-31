CREATE PROCEDURE [dbo].[ooOld]
	@arg varChar(50) = ''
    ,@table varChar(50) = ''
     ,@like varChar(50) = ''
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	select * from ooFun(@arg, @table, @like)

    
END
