

CREATE VIEW [dbo].[vWineVinNDetails]
WITH SCHEMABINDING

AS

	select 
		Wine_VinN_ID = vn.ID, 
		Wine_VinN_GroupID = vn.GroupID,

		Country = lc.Name, Region = lr.Name, Location = ll.Name, 
		Locale = lloc.Name, Site = ls.Name,
		Appellation = coalesce(
			nullif(ls.Name,''), nullif(lloc.name,''), nullif(ll.name,''), nullif(lr.name,''), nullif(lc.name,'')
		),

		Producer = wp.Name, ProducerToShow = wp.NameToShow,
		[Type] = wt.Name, Label = wl.Name, 
		Variety = wv.Name, Dryness = wd.Name, Color = wc.Name,
		
		Name = rtrim(ltrim( rtrim(ltrim(wp.NameToShow + ' ' + wl.Name)) + ' ' + wv.Name)),

		locCountryID = vn.locCountryID, locRegionID = vn.locRegionID,
		locLocationID = vn.locLocationID, locLocaleID = vn.locLocaleID, locSiteID = vn.locSiteID,
		ProducerID = vn.ProducerID, TypeID = vn.TypeID, LabelID = vn.LabelID,
		VarietyID = vn.VarietyID, DrynessID = vn.DrynessID, ColorID = vn.ColorID,
		
		Wine_VinN_WF_StatusID = vn.WF_StatusID
	from dbo.Wine_VinN vn

		join dbo.WineProducer wp on vn.ProducerID = wp.ID
		join dbo.WineType wt on vn.TypeID = wt.ID
		join dbo.WineLabel wl on vn.LabelID = wl.ID
		join dbo.WineVariety wv on vn.VarietyID = wv.ID
		join dbo.WineDryness wd on vn.DrynessID = wd.ID
		join dbo.WineColor wc on vn.ColorID = wc.ID

		join dbo.LocationCountry lc on vn.locCountryID = lc.ID
		join dbo.LocationRegion lr on vn.locRegionID = lr.ID
		join dbo.LocationLocation ll on vn.locLocationID = ll.ID
		join dbo.LocationLocale lloc on vn.locLocaleID = lloc.ID
		join dbo.LocationSite ls on vn.locSiteID = ls.ID
	--where vn.WF_StatusID > 99
GO
CREATE UNIQUE CLUSTERED INDEX [PK_vWineVinNDetails]
    ON [dbo].[vWineVinNDetails]([Wine_VinN_ID] ASC)
    ON [WineIndx];


GO
GRANT SELECT
    ON OBJECT::[dbo].[vWineVinNDetails] TO [RP_DataAdmin]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[vWineVinNDetails] TO [RP_Customer]
    AS [dbo];

