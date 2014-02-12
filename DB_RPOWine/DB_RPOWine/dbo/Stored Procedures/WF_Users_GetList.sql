-- =============================================
-- Author:		Alex B.
-- Create date: 2/04/2014
-- Description:	Gets List of registered and available Users.
-- =============================================
CREATE PROCEDURE [dbo].[WF_Users_GetList]
	@ID int = NULL,
	@Name varchar(256) = NULL, @Login varchar(256) = NULL,
	@ShowRes smallint = 1

AS
set nocount on

if @ID is NOT NULL begin
	select 	
		ID = UserId, 
		Name = FullName,
		Login = UserName
	from Users (nolock)
	where UserId = @ID
end else begin
	select 	
		ID = UserId, 
		Name = FullName,
		Login = UserName
	from Users (nolock)
	where IsAvailable = 1
	order by Name
end

RETURN 1
GO
GRANT EXECUTE
    ON OBJECT::[dbo].[WF_Users_GetList] TO [RP_DataAdmin]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[WF_Users_GetList] TO PUBLIC
    AS [dbo];

