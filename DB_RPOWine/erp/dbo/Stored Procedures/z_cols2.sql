CREATE PROCEDURE [dbo].[z_cols2]
     @table varChar(50) = '',
     @like varChar(50) = '',
	@inOrder varChar(2) = 'tc'
	,@views varChar(2) = 'tv'
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	select * from colsT (@table, @like, @inorder, @views)

    
END



