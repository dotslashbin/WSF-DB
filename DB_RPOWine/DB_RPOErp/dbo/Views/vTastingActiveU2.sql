

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE view vTastingActiveU2 as (
	select row_number() over (partition by wineN order by [hasRating] DESC, isErpTasting DESC,[tasteDate] Desc,[wineN] ASC,[tastingN] ASC) iiActive,*
		from vTastingPlus
)
