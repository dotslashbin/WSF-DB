CREATE TABLE [dbo].[junk] (
    [a] INT NULL,
    [b] INT NULL,
    [c] INT NULL
);


GO


CREATE TRIGGER junkTrig
   ON  junk
   AFTER INSERT,DELETE,UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    if update(b) insert into junkk(z) select 'b updated with ' + convert(varchar, isnull(b, -1)) from inserted
   
  
  if exists(select * from deleted)
	insert into junkk(z) select 'generic delete'
  
  declare @delb int = null
  select top(1) @delb=b from deleted where b > 10
  if @delb is not null
	insert into junkk(z) select 'b='+convert(varchar, @delb)+' deleted '

END
