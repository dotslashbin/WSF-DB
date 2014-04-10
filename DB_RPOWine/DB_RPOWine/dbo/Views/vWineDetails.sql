



CREATE VIEW [dbo].[vWineDetails]
WITH SCHEMABINDING

AS

	select 
		Wine_N_ID = wn.ID, Wine_VinN_ID = vn.ID, 
		Wine_VinN_GroupID = vn.GroupID,

		Country = lc.Name, Region = lr.Name, Location = ll.Name, 
		Locale = lloc.Name, Site = ls.Name,
		Appellation = coalesce(
			nullif(ls.Name,''), nullif(lloc.name,''), nullif(ll.name,''), nullif(lr.name,''), nullif(lc.name,'')
		),

		Producer = wp.Name, ProducerToShow = wp.NameToShow, ProducerURL = wp.WebSiteURL, 
		ProducerProfileFileName = wp.ProfileFileName,
		
		[Type] = wt.Name, Label = wl.Name,
		Variety = wv.Name, Dryness = wd.Name, Color = wc.Name,
		Vintage = wvin.Name,
		
		Name = rtrim(ltrim(wp.NameToShow + ' ' + wl.Name + ' ' + wv.Name + ' ' + wvin.Name) + case
			when wl.DefaultDrynessID != wd.ID then ' ' + wd.Name
			else ''
		end + case
			when wl.DefaultColorID != wc.ID then ' ' + wc.Name
			else ''
		end),
		
		Keywords = isnull(lc.Name, '') + ' ' + isnull(lr.Name, '') 
			+ ' ' + isnull(ll.Name, '') + ' ' + isnull(lloc.Name, '') + ' ' + isnull(ls.Name,'')
			+ ' ' + isnull(wp.Name, '') + ' ' + isnull(wp.NameToShow, '') 
			+ ' ' + isnull(wt.Name, '') + ' ' + isnull(wl.Name, '')
			+ ' ' + isnull(wv.Name, '') + ' ' + isnull(wd.Name, '') + ' ' + isnull(wc.Name, '')
			+ ' ' + isnull(wvin.Name, ''),
		
		locCountryID = vn.locCountryID, locRegionID = vn.locRegionID,
		locLocationID = vn.locLocationID, locLocaleID = vn.locLocaleID, locSiteID = vn.locSiteID,
		ProducerID = vn.ProducerID, TypeID = vn.TypeID, LabelID = vn.LabelID,
		VarietyID = vn.VarietyID, DrynessID = vn.DrynessID, ColorID = vn.ColorID,
		VintageID = wn.VintageID,
		
		oldIdn = wn.oldIdn, oldEntryN = wn.oldEntryN, 
		oldFixedId = wn.oldFixedId, oldWineNameIdN = wn.oldWineNameIdN,

		Wine_N_WF_StatusID = wn.WF_StatusID,
		Vin_N_WF_StatusID = vn.WF_StatusID
		
	from dbo.Wine_N wn	-- (nolock)
		join dbo.Wine_VinN vn on wn.Wine_VinN_ID = vn.ID

		join dbo.WineProducer wp on vn.ProducerID = wp.ID
		join dbo.WineType wt on vn.TypeID = wt.ID
		join dbo.WineLabel wl on vn.LabelID = wl.ID
		join dbo.WineVariety wv on vn.VarietyID = wv.ID
		join dbo.WineDryness wd on vn.DrynessID = wd.ID
		join dbo.WineColor wc on vn.ColorID = wc.ID
		join dbo.WineVintage wvin on wn.VintageID = wvin.ID

		join dbo.LocationCountry lc on vn.locCountryID = lc.ID
		join dbo.LocationRegion lr on vn.locRegionID = lr.ID
		join dbo.LocationLocation ll on vn.locLocationID = ll.ID
		join dbo.LocationLocale lloc on vn.locLocaleID = lloc.ID
		join dbo.LocationSite ls on vn.locSiteID = ls.ID
	--where wn.WF_StatusID > 99
GO



GO

GO
--SET ARITHABORT ON
--GO
--SET CONCAT_NULL_YIELDS_NULL ON
--GO
--SET QUOTED_IDENTIFIER ON
--GO
--SET ANSI_NULLS ON
--GO
--SET ANSI_PADDING ON
--GO
--SET ANSI_WARNINGS ON
--GO
--SET NUMERIC_ROUNDABORT OFF
--GO
CREATE UNIQUE CLUSTERED INDEX [PK_vWineDetails] ON [dbo].[vWineDetails] 
(
	[Wine_N_ID] ASC
)WITH (STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) 
ON [WineIndx]
GO

CREATE FULLTEXT INDEX ON [dbo].[vWineDetails]
    ([Keywords] LANGUAGE 1033)
    KEY INDEX [PK_vWineDetails]
    ON ([RPOWine_FTSearchWine], FILEGROUP [WineIndx]);


GO


GO


GO
