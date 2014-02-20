-------- User List
insert into Users (UserId, UserName, IsAvailable) 
values (0, '', 0)
GO
exec srv.Users_Refresh
GO
------------------ update WineProducer - location ----------------
--- country
-- update WineProducer set locCountryID = 0
; with r as (
	select ProducerID, cnt=count(distinct locCountryID)
	from Wine_VinN v 
	group by ProducerID
)
update WineProducer set locCountryID = v.locCountryID
from r
	join WineProducer wp on r.ProducerID = wp.ID
	join Wine_VinN v on wp.ID = v.ProducerID
where cnt = 1

--select top 20 * from WineProducer where locCountryID = 0

--- region
; with r as (
	select ProducerID, cnt=count(distinct locRegionID)
	from Wine_VinN v 
	group by ProducerID
)
update WineProducer set locRegionID = v.locRegionID
from r
	join WineProducer wp on r.ProducerID = wp.ID
	join Wine_VinN v on wp.ID = v.ProducerID
where cnt = 1
