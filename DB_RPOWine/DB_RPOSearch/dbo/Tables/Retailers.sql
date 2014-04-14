CREATE TABLE [dbo].[Retailers] (
    [RetailerIdN]    INT            IDENTITY (1, 1) NOT NULL,
    [retailerN]      INT            NULL,
    [RetailerCode]   NVARCHAR (MAX) NULL,
    [RetailerName]   NVARCHAR (MAX) NULL,
    [Address]        NVARCHAR (MAX) NULL,
    [City]           NVARCHAR (MAX) NULL,
    [State]          NVARCHAR (MAX) NULL,
    [Zip]            NVARCHAR (MAX) NULL,
    [Country]        NVARCHAR (MAX) NULL,
    [ShipToCountry]  NVARCHAR (MAX) NULL,
    [Phone]          NVARCHAR (MAX) NULL,
    [Fax]            NVARCHAR (MAX) NULL,
    [Email]          NVARCHAR (MAX) NULL,
    [URL]            NVARCHAR (MAX) NULL,
    [Errors]         NVARCHAR (MAX) NULL,
    [Warnings]       NVARCHAR (MAX) NULL,
    [ErrorsOnReadin] NVARCHAR (MAX) NULL,
    CONSTRAINT [PK_Retailers] PRIMARY KEY CLUSTERED ([RetailerIdN] ASC)
);

