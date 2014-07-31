CREATE TABLE [dbo].[waForSale] (
    [ID]                          INT            NOT NULL,
    [WineAlert ID]                NVARCHAR (255) NULL,
    [WineN]                       NVARCHAR (255) NULL,
    [Vintage]                     NVARCHAR (255) NULL,
    [Bottle Size]                 NVARCHAR (255) NULL,
    [Retailer]                    NVARCHAR (255) NULL,
    [Price]                       FLOAT (53)     NULL,
    [Currency]                    NVARCHAR (255) NULL,
    [Tax/Notes]                   NVARCHAR (255) NULL,
    [URL]                         NVARCHAR (MAX) NULL,
    [Actual Retailer Description] NVARCHAR (255) NULL,
    [Overide Price Exception]     NVARCHAR (255) NULL,
    [Auction]                     NVARCHAR (255) NULL,
    [errors]                      NVARCHAR (MAX) NULL,
    [warnings]                    NVARCHAR (MAX) NULL,
    [phase]                       NVARCHAR (30)  NULL,
    [wineNN]                      INT            NULL,
    [retailerN]                   INT            NULL,
    [dollarsPerLiter]             FLOAT (53)     NULL
);

