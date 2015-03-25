CREATE TABLE [dbo].[Wine_N] (
    [ID]                        INT           IDENTITY (1, 1) NOT NULL,
    [Wine_VinN_ID]              INT           NOT NULL,
    [VintageID]                 INT           NOT NULL,
    [oldIdn]                    INT           NULL,
    [oldEntryN]                 INT           NULL,
    [oldFixedId]                INT           NULL,
    [oldWineNameIdN]            INT           NULL,
    [oldWineN]                  INT           NULL,
    [oldVinN]                   INT           NULL,
    [created]                   SMALLDATETIME CONSTRAINT [DF_Wine_N_created] DEFAULT (getdate()) NOT NULL,
    [updated]                   SMALLDATETIME NULL,
    [WF_StatusID]               SMALLINT      CONSTRAINT [DF_Wine_N_WF_StatusID] DEFAULT ((0)) NOT NULL,
    [MostRecentPrice]           MONEY         NULL,
    [MostRecentPriceHi]         MONEY         NULL,
    [MostRecentPriceCnt]        INT           NULL,
    [MostRecentAuctionPrice]    MONEY         NULL,
    [MostRecentAuctionPriceHi]  MONEY         NULL,
    [MostRecentAuctionPriceCnt] INT           NULL,
    [hasWJTasting]              BIT           NULL,
    [hasERPTasting]             BIT           NULL,
    [IsCurrentlyForSale]        BIT           NULL,
    [IsCurrentlyOnAuction]      BIT           NULL,
    [RV]                        ROWVERSION    NOT NULL,
    CONSTRAINT [PK_Wine_N] PRIMARY KEY CLUSTERED ([ID] ASC) ON [Wine],
    CONSTRAINT [FK_Wine_N_Wine_VinN] FOREIGN KEY ([Wine_VinN_ID]) REFERENCES [dbo].[Wine_VinN] ([ID]),
    CONSTRAINT [FK_Wine_N_WineVintage] FOREIGN KEY ([VintageID]) REFERENCES [dbo].[WineVintage] ([ID])
);


















GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_Wine_N_Uniq]
    ON [dbo].[Wine_N]([Wine_VinN_ID] ASC, [VintageID] ASC)
    INCLUDE([ID], [WF_StatusID])
    ON [Wine];


GO
CREATE NONCLUSTERED INDEX [IX_Wine_N]
    ON [dbo].[Wine_N]([VintageID] ASC)
    ON [PRIMARY];


GO
CREATE NONCLUSTERED INDEX [IX_Wine_N_23Update_oldVinN]
    ON [dbo].[Wine_N]([oldWineN] ASC)
    INCLUDE([ID])
    ON [PRIMARY];


GO
--------------------------------
CREATE TRIGGER [dbo].[Wine_N_Change] ON [dbo].[Wine_N] 
FOR UPDATE, DELETE
AS
set nocount on

declare @d datetime = getdate()

if exists(select * from Inserted) begin
	-- update or add - only fields of interest

	-- add previous values if neccessary
	if not exists(select * from aud.Wine v join Inserted i on v.Wine_VinN_ID = i.Wine_VinN_ID) begin
		insert into aud.Wine (act, actDate, Wine_N_ID, Wine_VinN_ID, ChangeBits,
			GroupID, ProducerID, TypeID, LabelID, VarietyID, DrynessID, ColorID, 
			locCountryID, locRegionID, locLocationID, locLocaleID, locSiteID, VintageID,
			ProducerName, TypeName, LabelName, VarietyName, DrynessName, ColorName,
			locCountryName, locRegionName, locLocationName, locLocaleName, locSiteName,
			VintageName,
			WF_StatusID, oldVinN)
		select 
			Act = '___',
			ActDate = isnull(d.updated, d.created),
			Wine_N_ID = d.ID,
			Wine_VinN_ID = d.Wine_VinN_ID, 
			ChangeBits = 0,
			vin.GroupID, vin.ProducerID, vin.TypeID, vin.LabelID, vin.VarietyID, vin.DrynessID, vin.ColorID, 
			vin.locCountryID, vin.locRegionID, vin.locLocationID, vin.locLocaleID, vin.locSiteID, 
			VintageID = d.VintageID,
			ProducerName = wp.Name, 
			TypeName = wt.Name, 
			LabelName = wl.Name, 
			VarietyName = wv.Name, 
			DrynessName = wd.Name, 
			ColorName = wc.Name,
			locCountryName = lc.Name, 
			locRegionName = lr.Name, 
			locLocationName = ll.Name, 
			locLocaleName = lloc.Name, 
			locSiteName = ls.Name,
			VintageName = vint.Name,
			d.WF_StatusID, d.oldVinN
		from Inserted i
			join Deleted d on i.ID = d.ID
			join Wine_VinN vin (nolock) on d.Wine_VinN_ID = vin.ID
			join dbo.WineProducer wp (nolock) on vin.ProducerID = wp.ID
			join dbo.WineType wt (nolock) on vin.TypeID = wt.ID
			join dbo.WineLabel wl (nolock) on vin.LabelID = wl.ID
			join dbo.WineVariety wv (nolock) on vin.VarietyID = wv.ID
			join dbo.WineDryness wd (nolock) on vin.DrynessID = wd.ID
			join dbo.WineColor wc (nolock) on vin.ColorID = wc.ID
			join dbo.LocationCountry lc (nolock) on vin.locCountryID = lc.ID
			join dbo.LocationRegion lr (nolock) on vin.locRegionID = lr.ID
			join dbo.LocationLocation ll (nolock) on vin.locLocationID = ll.ID
			join dbo.LocationLocale lloc (nolock) on vin.locLocaleID = lloc.ID
			join dbo.LocationSite ls (nolock) on vin.locSiteID = ls.ID
			join dbo.WineVintage vint (nolock) on d.VintageID = vint.ID
		where (
			i.Wine_VinN_ID != d.Wine_VinN_ID 
			or i.VintageID != d.VintageID
			)
	end
	
	-- add new values
	insert into aud.Wine (act, actDate, Wine_N_ID, Wine_VinN_ID, ChangeBits,
		GroupID, ProducerID, TypeID, LabelID, VarietyID, DrynessID, ColorID, 
		locCountryID, locRegionID, locLocationID, locLocaleID, locSiteID, VintageID,
		ProducerName, TypeName, LabelName, VarietyName, DrynessName, ColorName,
		locCountryName, locRegionName, locLocationName, locLocaleName, locSiteName,
		VintageName,
		WF_StatusID, oldVinN)
	select 
		Act = 'UPD',
		ActDate = @d,
		Wine_N_ID = i.ID,
		Wine_VinN_ID = i.Wine_VinN_ID, 
		ChangeBits = 0 
			+ case when i.Wine_VinN_ID != d.Wine_VinN_ID then 8192 else 0 end
			+ case when i.VintageID != d.VintageID then 16384 else 0 end
		,
		vin.GroupID, vin.ProducerID, vin.TypeID, vin.LabelID, vin.VarietyID, vin.DrynessID, vin.ColorID, 
		vin.locCountryID, vin.locRegionID, vin.locLocationID, vin.locLocaleID, vin.locSiteID, 
		VintageID = i.VintageID,
		ProducerName = wp.Name, 
		TypeName = wt.Name, 
		LabelName = wl.Name, 
		VarietyName = wv.Name, 
		DrynessName = wd.Name, 
		ColorName = wc.Name,
		locCountryName = lc.Name, 
		locRegionName = lr.Name, 
		locLocationName = ll.Name, 
		locLocaleName = lloc.Name, 
		locSiteName = ls.Name,
		VintageName = vint.Name,
		i.WF_StatusID, i.oldVinN
	from Inserted i
		join Deleted d on i.ID = d.ID
		join Wine_VinN vin (nolock) on i.Wine_VinN_ID = vin.ID
		join dbo.WineProducer wp (nolock) on vin.ProducerID = wp.ID
		join dbo.WineType wt (nolock) on vin.TypeID = wt.ID
		join dbo.WineLabel wl (nolock) on vin.LabelID = wl.ID
		join dbo.WineVariety wv (nolock) on vin.VarietyID = wv.ID
		join dbo.WineDryness wd (nolock) on vin.DrynessID = wd.ID
		join dbo.WineColor wc (nolock) on vin.ColorID = wc.ID
		join dbo.LocationCountry lc (nolock) on vin.locCountryID = lc.ID
		join dbo.LocationRegion lr (nolock) on vin.locRegionID = lr.ID
		join dbo.LocationLocation ll (nolock) on vin.locLocationID = ll.ID
		join dbo.LocationLocale lloc (nolock) on vin.locLocaleID = lloc.ID
		join dbo.LocationSite ls (nolock) on vin.locSiteID = ls.ID
		join dbo.WineVintage vint (nolock) on i.VintageID = vint.ID
	where (
		i.Wine_VinN_ID != d.Wine_VinN_ID 
		or i.VintageID != d.VintageID
	)
end else begin
	-- delete
	insert into aud.Wine (act, actDate, Wine_N_ID, Wine_VinN_ID, ChangeBits,
		GroupID, ProducerID, TypeID, LabelID, VarietyID, DrynessID, ColorID, 
		locCountryID, locRegionID, locLocationID, locLocaleID, locSiteID, VintageID,
		ProducerName, TypeName, LabelName, VarietyName, DrynessName, ColorName,
		locCountryName, locRegionName, locLocationName, locLocaleName, locSiteName,
		VintageName,
		WF_StatusID, oldVinN)
	select 
		Act = 'DEL', 
		ActDate = @d,
		Wine_N_ID = d.ID,
		Wine_VinN_ID = d.Wine_VinN_ID, 
		ChangeBits = 0,	-- to minimize list for delete operations	32767 -- max smallint (all fields are changed)
		vin.GroupID, vin.ProducerID, vin.TypeID, vin.LabelID, vin.VarietyID, vin.DrynessID, vin.ColorID, 
		vin.locCountryID, vin.locRegionID, vin.locLocationID, vin.locLocaleID, vin.locSiteID, 
		VintageID = d.VintageID,
		ProducerName = wp.Name, 
		TypeName = wt.Name, 
		LabelName = wl.Name, 
		VarietyName = wv.Name, 
		DrynessName = wd.Name, 
		ColorName = wc.Name,
		locCountryName = lc.Name, 
		locRegionName = lr.Name, 
		locLocationName = ll.Name, 
		locLocaleName = lloc.Name, 
		locSiteName = ls.Name,
		VintageName = vint.Name,
		d.WF_StatusID, d.oldVinN
	from Deleted d
		join Wine_VinN vin (nolock) on d.Wine_VinN_ID = vin.ID
		join dbo.WineProducer wp (nolock) on vin.ProducerID = wp.ID
		join dbo.WineType wt (nolock) on vin.TypeID = wt.ID
		join dbo.WineLabel wl (nolock) on vin.LabelID = wl.ID
		join dbo.WineVariety wv (nolock) on vin.VarietyID = wv.ID
		join dbo.WineDryness wd (nolock) on vin.DrynessID = wd.ID
		join dbo.WineColor wc (nolock) on vin.ColorID = wc.ID
		join dbo.LocationCountry lc (nolock) on vin.locCountryID = lc.ID
		join dbo.LocationRegion lr (nolock) on vin.locRegionID = lr.ID
		join dbo.LocationLocation ll (nolock) on vin.locLocationID = ll.ID
		join dbo.LocationLocale lloc (nolock) on vin.locLocaleID = lloc.ID
		join dbo.LocationSite ls (nolock) on vin.locSiteID = ls.ID
		join dbo.WineVintage vint (nolock) on d.VintageID = vint.ID
end

__commit:
	goto __exit
__rollback:
	ROLLBACK TRANSACTION
__exit: