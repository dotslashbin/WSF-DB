create view vRatingRange as

with 

a as (select

wineN

, case 

when rating between 96 and 100 then 100

when rating between 90 and 95 then 95

when rating between 80 and 89 then 89

when rating between 70 and 79 then 79

else 69

end ratingRange

from erp..tasting

)

select 

wineN,

ratingRange, 

COUNT(*) cntTastingsInThisRange

from a

group by wineN, ratingRange


