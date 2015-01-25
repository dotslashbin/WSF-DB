CREATE TABLE [dbo].[Wine_VinN] (
    [ID]            INT           IDENTITY (1, 1) NOT NULL,
    [GroupID]       INT           CONSTRAINT [DF_Wine_VinN_GroupID] DEFAULT ((0)) NOT NULL,
    [ProducerID]    INT           NOT NULL,
    [TypeID]        INT           NOT NULL,
    [LabelID]       INT           NOT NULL,
    [VarietyID]     INT           NOT NULL,
    [DrynessID]     INT           NOT NULL,
    [ColorID]       INT           NOT NULL,
    [locCountryID]  INT           NOT NULL,
    [locRegionID]   INT           NOT NULL,
    [locLocationID] INT           NOT NULL,
    [locLocaleID]   INT           NOT NULL,
    [locSiteID]     INT           NOT NULL,
    [created]       SMALLDATETIME CONSTRAINT [DF_Wine_VinN_created] DEFAULT (getdate()) NOT NULL,
    [updated]       SMALLDATETIME NULL,
    [WF_StatusID]   SMALLINT      CONSTRAINT [DF_Wine_VinN_WF_StatusID] DEFAULT ((0)) NOT NULL,
    [oldVinN]       INT           NULL,
    CONSTRAINT [PK_Wine_VinN] PRIMARY KEY CLUSTERED ([ID] ASC) ON [Wine],
    CONSTRAINT [FK_Wine_VinN_LocationCountry] FOREIGN KEY ([locCountryID]) REFERENCES [dbo].[LocationCountry] ([ID]),
    CONSTRAINT [FK_Wine_VinN_LocationLocale] FOREIGN KEY ([locLocaleID]) REFERENCES [dbo].[LocationLocale] ([ID]),
    CONSTRAINT [FK_Wine_VinN_LocationLocation] FOREIGN KEY ([locLocationID]) REFERENCES [dbo].[LocationLocation] ([ID]),
    CONSTRAINT [FK_Wine_VinN_LocationRegion] FOREIGN KEY ([locRegionID]) REFERENCES [dbo].[LocationRegion] ([ID]),
    CONSTRAINT [FK_Wine_VinN_LocationSite] FOREIGN KEY ([locSiteID]) REFERENCES [dbo].[LocationSite] ([ID]),
    CONSTRAINT [FK_Wine_VinN_WineColor] FOREIGN KEY ([ColorID]) REFERENCES [dbo].[WineColor] ([ID]),
    CONSTRAINT [FK_Wine_VinN_WineDryness] FOREIGN KEY ([DrynessID]) REFERENCES [dbo].[WineDryness] ([ID]),
    CONSTRAINT [FK_Wine_VinN_WineLabel] FOREIGN KEY ([LabelID]) REFERENCES [dbo].[WineLabel] ([ID]),
    CONSTRAINT [FK_Wine_VinN_WineProducer] FOREIGN KEY ([ProducerID]) REFERENCES [dbo].[WineProducer] ([ID]),
    CONSTRAINT [FK_Wine_VinN_WineType] FOREIGN KEY ([TypeID]) REFERENCES [dbo].[WineType] ([ID]),
    CONSTRAINT [FK_Wine_VinN_WineVariety] FOREIGN KEY ([VarietyID]) REFERENCES [dbo].[WineVariety] ([ID])
);










GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_Wine_VinN_Uniq]
    ON [dbo].[Wine_VinN]([ProducerID] ASC, [TypeID] ASC, [LabelID] ASC, [VarietyID] ASC, [DrynessID] ASC, [ColorID] ASC, [locCountryID] ASC, [locRegionID] ASC, [locLocationID] ASC, [locLocaleID] ASC, [locSiteID] ASC)
    INCLUDE([ID], [GroupID], [WF_StatusID])
    ON [Wine];


GO
CREATE NONCLUSTERED INDEX [IX_Wine_VinN_locSiteID]
    ON [dbo].[Wine_VinN]([locSiteID] ASC)
    INCLUDE([ID], [GroupID], [ProducerID], [TypeID], [LabelID], [VarietyID], [DrynessID], [ColorID], [locCountryID], [locRegionID], [locLocationID], [locLocaleID], [WF_StatusID], [oldVinN])
    ON [Wine];




GO
CREATE NONCLUSTERED INDEX [IX_Wine_VinN_locRegionID]
    ON [dbo].[Wine_VinN]([locRegionID] ASC)
    INCLUDE([ID], [GroupID], [ProducerID], [TypeID], [LabelID], [VarietyID], [DrynessID], [ColorID], [locCountryID], [locLocationID], [locLocaleID], [locSiteID], [WF_StatusID], [oldVinN])
    ON [Wine];




GO
CREATE NONCLUSTERED INDEX [IX_Wine_VinN_locLocationID]
    ON [dbo].[Wine_VinN]([locLocationID] ASC)
    INCLUDE([ID], [GroupID], [ProducerID], [TypeID], [LabelID], [VarietyID], [DrynessID], [ColorID], [locCountryID], [locRegionID], [locLocaleID], [locSiteID], [WF_StatusID], [oldVinN])
    ON [Wine];




GO
CREATE NONCLUSTERED INDEX [IX_Wine_VinN_locLocaleID]
    ON [dbo].[Wine_VinN]([locLocaleID] ASC)
    INCLUDE([ID], [GroupID], [ProducerID], [TypeID], [LabelID], [VarietyID], [DrynessID], [ColorID], [locCountryID], [locRegionID], [locLocationID], [locSiteID], [WF_StatusID], [oldVinN])
    ON [Wine];




GO
CREATE NONCLUSTERED INDEX [IX_Wine_VinN_locCountryID]
    ON [dbo].[Wine_VinN]([locCountryID] ASC)
    INCLUDE([ID], [GroupID], [ProducerID], [TypeID], [LabelID], [VarietyID], [DrynessID], [ColorID], [locRegionID], [locLocationID], [locLocaleID], [locSiteID], [WF_StatusID], [oldVinN])
    ON [Wine];




GO
CREATE NONCLUSTERED INDEX [IX_Wine_VinN_LabelID]
    ON [dbo].[Wine_VinN]([LabelID] ASC)
    INCLUDE([ID], [GroupID], [ProducerID], [TypeID], [VarietyID], [DrynessID], [ColorID], [locCountryID], [locRegionID], [locLocationID], [locLocaleID], [locSiteID], [WF_StatusID], [oldVinN])
    ON [PRIMARY];




GO
CREATE NONCLUSTERED INDEX [IX_Wine_VinN_ColorID]
    ON [dbo].[Wine_VinN]([ColorID] ASC)
    INCLUDE([ID], [ProducerID], [TypeID], [LabelID], [VarietyID], [DrynessID], [locCountryID], [locRegionID], [locLocationID])
    ON [Wine];


GO
CREATE TRIGGER [dbo].[Wine_VinN_Change] ON [dbo].[Wine_VinN] 
FOR UPDATE, DELETE
AS
set nocount on

declare @d datetime = getdate()

if exists(select * from Inserted) begin
	-- update or add - only fields of interest

	-- add previous values if neccessary
	if not exists(select * from aud.Wine v join Inserted i on v.Wine_VinN_ID = i.ID) begin
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
			Wine_N_ID = 0,
			Wine_VinN_ID = d.ID, 
			ChangeBits = 0,
			d.GroupID, d.ProducerID, d.TypeID, d.LabelID, d.VarietyID, d.DrynessID, d.ColorID, 
			d.locCountryID, d.locRegionID, d.locLocationID, d.locLocaleID, d.locSiteID, 
			VintageID = 0,
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
			VintageName = '',
			d.WF_StatusID, d.oldVinN
		from Inserted i
			join Deleted d on i.ID = d.ID
			join dbo.WineProducer wp (nolock) on d.ProducerID = wp.ID
			join dbo.WineType wt (nolock) on d.TypeID = wt.ID
			join dbo.WineLabel wl (nolock) on d.LabelID = wl.ID
			join dbo.WineVariety wv (nolock) on d.VarietyID = wv.ID
			join dbo.WineDryness wd (nolock) on d.DrynessID = wd.ID
			join dbo.WineColor wc (nolock) on d.ColorID = wc.ID
			join dbo.LocationCountry lc (nolock) on d.locCountryID = lc.ID
			join dbo.LocationRegion lr (nolock) on d.locRegionID = lr.ID
			join dbo.LocationLocation ll (nolock) on d.locLocationID = ll.ID
			join dbo.LocationLocale lloc (nolock) on d.locLocaleID = lloc.ID
			join dbo.LocationSite ls (nolock) on d.locSiteID = ls.ID
		where (i.GroupID != d.GroupID 
				or i.ProducerID != d.ProducerID
				or i.TypeID != d.TypeID
				or i.LabelID != d.LabelID
				or i.VarietyID != d.VarietyID
				or i.DrynessID != d.DrynessID
				or i.ColorID != d.ColorID
				or i.locCountryID != d.locCountryID
				or i.locRegionID != d.locRegionID
				or i.locLocationID != d.locLocationID
				or i.locLocaleID != d.locLocaleID
				or i.locSiteID != d.locSiteID
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
		Wine_N_ID = 0,
		Wine_VinN_ID = i.ID, 
		ChangeBits = 0 
			+ case when i.GroupID != d.GroupID then 2 else 0 end
			+ case when i.ProducerID != d.ProducerID then 4 else 0 end
			+ case when i.TypeID != d.TypeID then 8 else 0 end
			+ case when i.LabelID != d.LabelID then 16 else 0 end
			+ case when i.VarietyID != d.VarietyID then 32 else 0 end
			+ case when i.DrynessID != d.DrynessID then 64 else 0 end
			+ case when i.ColorID != d.ColorID then 128 else 0 end
			+ case when i.locCountryID != d.locCountryID then 256 else 0 end
			+ case when i.locRegionID != d.locRegionID then 512 else 0 end
			+ case when i.locLocationID != d.locLocationID then 1024 else 0 end
			+ case when i.locLocaleID != d.locLocaleID then 2048 else 0 end
			+ case when i.locSiteID != d.locSiteID then 4096 else 0 end,
		i.GroupID, i.ProducerID, i.TypeID, i.LabelID, i.VarietyID, i.DrynessID, i.ColorID, 
		i.locCountryID, i.locRegionID, i.locLocationID, i.locLocaleID, i.locSiteID, 
		VintageID = 0,
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
		VintageName = '',
		i.WF_StatusID, i.oldVinN
	from Inserted i
		join Deleted d on i.ID = d.ID
		join dbo.WineProducer wp (nolock) on i.ProducerID = wp.ID
		join dbo.WineType wt (nolock) on i.TypeID = wt.ID
		join dbo.WineLabel wl (nolock) on i.LabelID = wl.ID
		join dbo.WineVariety wv (nolock) on i.VarietyID = wv.ID
		join dbo.WineDryness wd (nolock) on i.DrynessID = wd.ID
		join dbo.WineColor wc (nolock) on i.ColorID = wc.ID
		join dbo.LocationCountry lc (nolock) on i.locCountryID = lc.ID
		join dbo.LocationRegion lr (nolock) on i.locRegionID = lr.ID
		join dbo.LocationLocation ll (nolock) on i.locLocationID = ll.ID
		join dbo.LocationLocale lloc (nolock) on i.locLocaleID = lloc.ID
		join dbo.LocationSite ls (nolock) on i.locSiteID = ls.ID

	where (
		i.GroupID != d.GroupID 
		or i.ProducerID != d.ProducerID
		or i.TypeID != d.TypeID
		or i.LabelID != d.LabelID
		or i.VarietyID != d.VarietyID
		or i.DrynessID != d.DrynessID
		or i.ColorID != d.ColorID
		or i.locCountryID != d.locCountryID
		or i.locRegionID != d.locRegionID
		or i.locLocationID != d.locLocationID
		or i.locLocaleID != d.locLocaleID
		or i.locSiteID != d.locSiteID
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
		Wine_N_ID = 0,
		Wine_VinN_ID = d.ID, 
		ChangeBits = 0,	-- to minimize list for delete operations	32767 -- max smallint (all fields are changed)
		d.GroupID, d.ProducerID, d.TypeID, d.LabelID, d.VarietyID, d.DrynessID, d.ColorID, 
		d.locCountryID, d.locRegionID, d.locLocationID, d.locLocaleID, d.locSiteID, 
		VintageID = 0,
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
		VintageName = '',
		d.WF_StatusID, d.oldVinN
	from Deleted d
		join dbo.WineProducer wp (nolock) on d.ProducerID = wp.ID
		join dbo.WineType wt (nolock) on d.TypeID = wt.ID
		join dbo.WineLabel wl (nolock) on d.LabelID = wl.ID
		join dbo.WineVariety wv (nolock) on d.VarietyID = wv.ID
		join dbo.WineDryness wd (nolock) on d.DrynessID = wd.ID
		join dbo.WineColor wc (nolock) on d.ColorID = wc.ID
		join dbo.LocationCountry lc (nolock) on d.locCountryID = lc.ID
		join dbo.LocationRegion lr (nolock) on d.locRegionID = lr.ID
		join dbo.LocationLocation ll (nolock) on d.locLocationID = ll.ID
		join dbo.LocationLocale lloc (nolock) on d.locLocaleID = lloc.ID
		join dbo.LocationSite ls (nolock) on d.locSiteID = ls.ID
end

__commit:
	goto __exit
__rollback:
	ROLLBACK TRANSACTION
__exit: