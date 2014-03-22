-- ======= Article Meta Tags ========
--
-- Data Source: ArticlesParser.dbo
--
--
USE [RPOWine]
GO
print '--------- copy data --------'
GO
-------- Cuisine
set identity_insert Cuisine on
insert into Cuisine (ID, Name, WF_StatusID) values (0, N'', 0)
set identity_insert Cuisine off
go
insert into Cuisine (Name, WF_StatusID)
select a.Cuisine, WF_StatusID = 100
from ArticlesParser.dbo.Articles a
	left join Cuisine c on a.Cuisine = c.Name
where a.Cuisine is not null and LEN(a.Cuisine) > 0 and c.ID is NULL
	and a.Cuisine != 'xxxx'
group by a.Cuisine
GO
