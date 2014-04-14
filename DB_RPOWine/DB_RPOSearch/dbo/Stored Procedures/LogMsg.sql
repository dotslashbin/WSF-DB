CREATE PROCEDURE [dbo].[LogMsg] 
	@Description VarChar(255), @Counter bigInt = null
	
AS
BEGIN
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	declare  @Id int
    Set @id =  ident_current('ActionLog')
	if @counter is not null and exists (select 1 from ActionLog where idN = @Id and ActionDescription = @description)
		 update ActionLog set ActionDate = getDate(), Counter = @counter where idN = @id;
	else
		 insert into ActionLog(ActionDate, ActionDescription, Counter) 
		 values (getDate(), @Description, @Counter);
END

RETURN 1
