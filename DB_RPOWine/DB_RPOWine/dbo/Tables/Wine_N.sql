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

