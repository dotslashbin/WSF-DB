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

