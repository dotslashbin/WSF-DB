-- ======= Publication Types ========
--
-- Data Source: RPOWineData.dbo, Membership..aspnet_Users
--
--
USE [RPOWine]
GO
print '--------- copy data --------'

-------- Publisher : NOTE : 0 record allowed only for a transition time! ---------------
begin tran
	set identity_insert Publisher on
	insert into Publisher (ID, Name, IsPrimary)
	values (0, '', 0), (1, 'TWA', 1), (2, 'DA', 0)
	set identity_insert Publisher off
commit tran
GO

-------- Publication : NOTE : no 0 records allowed! ----------
; with r as (
	select PubName = case
		when Publication like '%robertpark%' then 'eRobertParker.com'
		when Publication like 'Executive Wine Seminar%' then 'Executive Wine Seminar'
		else Publication
	end
	from RPOWineData.dbo.Wine
	group by case
		when Publication like '%robertpark%' then 'eRobertParker.com'
		when Publication like 'Executive Wine Seminar%' then 'Executive Wine Seminar'
		else Publication
	end
)
insert into [Publication] (PublisherID, Name)
select 
	PublisherID = case 
		when PubName = 'eRobertParker.com' then 1 
		when PubName like 'Bordeaux%' then 1 
		when PubName like 'Burgundy%' then 1 
		when PubName like 'Buying%' then 1 
		else 2
	end,
	Name = PubName
from r
order by case when PubName = 'eRobertParker.com' then '!!!' else '' end + PubName
GO

--------- Reviewer
--set identity_insert Reviewer on
--insert into Reviewer (ID, Name, UserId, oldReviewerIdN, WF_StatusID) values (0, N'', 0, 1, 100)
--set identity_insert Reviewer off
--go
--; with r as (
--	select 
--		Name = isnull([Source], ''),
--		UserName = '', 
--		oldReviewerIdN = ReviewerIdN, 
--		WF_StatusID = 100,
--		cnt = count(*)
--	from RPOWineData.dbo.Wine
--	group by ReviewerIdN, Source
--)
--insert into Reviewer (Name, UserId, oldReviewerIdN, WF_StatusID)
--select Name, UserId = isnull(u.UserId, 0), oldReviewerIdN, WF_StatusID
--from r
--	left join Membership..aspnet_Users u on r.Name != '' and r.Name != 'Robert Parker' 
--		and u.UserName like '%' + replace(r.Name, ' ', '%') + '%'
--where Name != ''
--order by cnt desc
--GO
--select * from Users
GO
exec srv.Users_Refresh
GO
; with r as (
	select 
		Name = isnull([Source], ''),
		RN = row_number() over(order by Source),
		cnt = count(*)
	from RPOWineData.dbo.Wine
	group by Source
)
insert into Users ([UserId],[UserName],[FirstName],[LastName],[IsAvailable],[created])
select UserId = min(isnull(u.UserId, -1*RN)), 
	UserName = lower(replace(Name, ' ', '')), 
	Name, '', 0, getdate()
from r
	left join Membership..aspnet_Users u on 
		u.UserName like '%' + replace(replace(r.Name,'-',''), ' ', '%') + '%'
	left join Users us on u.UserId = us.UserId or us.FullName = case
		when r.Name = 'Robert Parker' then 'Robert M. Parker, Jr.' 
		when r.Name = 'Jay Miller' then 'Jay S Miller' 
		else r.Name
	end	
where r.Name != '' and us.UserId is NULL
group by lower(replace(Name, ' ', '')), Name
GO