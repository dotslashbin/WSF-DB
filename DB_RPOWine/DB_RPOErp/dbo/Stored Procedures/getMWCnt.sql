-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE getMWCnt 
	-- Add the parameters for the stored procedure here
	@MWcnt INT OUTPUT

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

   select count(*) from wh 
   left join Membership.dbo.Erp_ProfileUnwrap as a on wh.memberId =a.userid 
   left join Membership.dbo.aspnet_UsersInRoles as b on wh.memberId =b.userid 
   where wh.isProfessionalTaster <> 1 And wh.memberId Is Not null 
   and wh.email not like '%@winetech.com' 
   and b.roleId=27 
   and a.SubscriptionExpiration>GETDATE()
   
END
