create view vRating as

select 

wineN, rating, 

COUNT(*) cntTastingsWithThisRating 

from erp..tasting 

group by wineN, rating

