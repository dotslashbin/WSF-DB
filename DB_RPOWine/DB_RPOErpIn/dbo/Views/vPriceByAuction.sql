create view vPriceByAuction as
	select 0 includesAuction, * from vDollarsWithNoAuction
	union
	select 1 includesAuction, * from vDollarsWithAuction
