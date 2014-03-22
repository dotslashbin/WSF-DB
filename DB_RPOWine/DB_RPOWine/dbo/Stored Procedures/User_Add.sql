-- =============================================
-- Author:		Alex B.
-- Create date: 3/15/2014
-- Description:	Adds user record from Membership database.
--				REQUIRES dbo privilages to access Membership database.
-- =============================================
CREATE PROCEDURE [dbo].[User_Add]
	@UserId int = NULL

AS
set nocount on;
set xact_abort on;

if exists(select * from Users where UserId = @UserId)
	RETURN 1

declare @appID varchar(256) = '37F84C52-ABF3-493E-9368-655401FB1C90'

BEGIN TRAN

	merge Users as t
		using (
			select distinct u.UserId, UserName=lower(u.UserName),
				FirstName = name.value('(./FirstName)[1]', 'varchar(256)'),
				LastName = name.value('(./LastName)[1]', 'varchar(256)'),
				IsAvailable = case 
					when m.IsApproved = 1 and m.IsLockedOut = 0	and r.LoweredRoleName in (
						'erp_role_AdminEditor',
						'erp_role_TWAReviewer',
						'erp_role_ChiefEditor',
						'erp_role_Editor',
						'erp_role_SubEditor'
						) then 1
					else 0
				end
			from dbo.SYN_t_MembershipUsers u (nolock)
				join dbo.SYN_t_MembershipMembership m (nolock) on u.UserId = m.UserId
				join dbo.SYN_t_MembershipUsersInRoles ur (nolock) on u.UserId = ur.UserId
				join dbo.SYN_t_MembershipRoles r (nolock) on ur.RoleId = r.RoleId
				left join dbo.SYN_t_MembershipErp_Profile p (nolock) on u.UserId = p.UserId
				cross apply p.PropertyValues.nodes('/profile') as ref(name)
			where r.ApplicationId = @appID
				and u.UserId = @UserId
		) as s
		on t.UserId = s.UserId
		when matched then
			UPDATE set
				UserName = s.UserName,
				FirstName = s.FirstName,
				LastName = s.LastName,
				IsAvailable = s.IsAvailable,
				updated = getdate()
		when not matched then
			INSERT (UserId, UserName, FirstName, LastName, IsAvailable, created)
			values (s.UserId, s.UserName, s.FirstName, s.LastName, s.IsAvailable, getdate());
	
COMMIT TRAN

RETURN 1
GO
GRANT EXECUTE
    ON OBJECT::[dbo].[User_Add] TO [RP_DataAdmin]
    AS [dbo];

