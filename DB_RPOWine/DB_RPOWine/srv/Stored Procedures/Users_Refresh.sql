-- =============================================
-- Author:		Alex B.
-- Create date: 2/11/2014
-- Description:	Refreshes list of users from Membership database.
--				Supposed to be ran preiodically by SQL Service Agent.
--				REQUIRES dbo privilages to access Membership database.
-- =============================================
CREATE PROCEDURE srv.Users_Refresh

AS
set nocount on;
set xact_abort on;

declare @appID varchar(256) = '37F84C52-ABF3-493E-9368-655401FB1C90'

BEGIN TRAN
	update Users set IsAvailable = 0
	
	merge Users as t
		using (
			select distinct u.UserId, UserName=lower(u.UserName),
				FirstName = name.value('(./FirstName)[1]', 'varchar(256)'),
				LastName = name.value('(./LastName)[1]', 'varchar(256)')
			from dbo.SYN_t_MembershipUsers u (nolock)
				join dbo.SYN_t_MembershipMembership m (nolock) on u.UserId = m.UserId
				join dbo.SYN_t_MembershipUsersInRoles ur (nolock) on u.UserId = ur.UserId
				join dbo.SYN_t_MembershipRoles r (nolock) on ur.RoleId = r.RoleId
				left join dbo.SYN_t_MembershipErp_Profile p (nolock) on u.UserId = p.UserId
				cross apply p.PropertyValues.nodes('/profile') as ref(name)
			where r.ApplicationId = @appID
				and m.IsApproved = 1 and m.IsLockedOut = 0
				and r.LoweredRoleName in ('erp_role_editoradmin','erp_role_editorreviewer')
		) as s
		on t.UserId = s.UserId
		when matched then
			UPDATE set
				UserName = s.UserName,
				FirstName = s.FirstName,
				LastName = s.LastName,
				IsAvailable = 1,
				updated = getdate()
		when not matched then
			INSERT (UserId, UserName, FirstName, LastName, IsAvailable, created)
			values (s.UserId, s.UserName, s.FirstName, s.LastName, 1, getdate());
	
COMMIT TRAN

RETURN 1