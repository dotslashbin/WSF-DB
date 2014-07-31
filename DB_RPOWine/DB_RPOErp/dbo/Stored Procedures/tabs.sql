CREATE PROCEDURE [dbo].[tabs]
	-- Add the parameters for the stored procedure here
     @table varChar(50) = ''
	 ,@arg varChar(2) = 't'
	,@views varChar(2) = 't'
AS
BEGIN
	SET NOCOUNT ON;
	if @arg <> 'tt' set @arg = 't'	
	select tb from colsT (@table, '', @arg, @views)
END
