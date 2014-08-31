create proc updateTastingVinnWineNameN as begin
			update a
				set a.wineNameN = b.wineNameN
					, a.vinn = b.activeVinn
				from tasting a
					join wine b
						on a.wineN = b.wineN
				where 
						(a.wineNameN is null and b.wineNameN is not null)
						or (a.wineNameN is not null and b.wineNameN is null)
						or (a.wineNameN <> b.wineNameN)
						or (a.Vinn is null and b.activeVinn is not null)
						or (a.Vinn is not null and b.activeVinn is null)
						or (a.Vinn <> b.activeVinn)
end
