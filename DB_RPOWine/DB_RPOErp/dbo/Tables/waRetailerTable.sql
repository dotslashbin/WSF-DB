CREATE TABLE [dbo].[waRetailerTable] (
    [ID]              INT            NOT NULL,
    [Retailer-Code]   NVARCHAR (255) NULL,
    [Retailer-Name]   NVARCHAR (255) NULL,
    [Address]         NVARCHAR (255) NULL,
    [City]            NVARCHAR (255) NULL,
    [State]           NVARCHAR (255) NULL,
    [Zip]             NVARCHAR (255) NULL,
    [Country]         NVARCHAR (255) NULL,
    [Ship-to-Country] NVARCHAR (255) NULL,
    [Phone]           NVARCHAR (255) NULL,
    [Fax]             NVARCHAR (255) NULL,
    [Email]           NVARCHAR (255) NULL,
    [URL]             NVARCHAR (MAX) NULL,
    [errors]          NVARCHAR (MAX) NULL,
    [warnings]        NVARCHAR (MAX) NULL,
    [retailerN]       INT            NULL
);

