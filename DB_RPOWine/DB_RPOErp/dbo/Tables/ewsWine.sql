CREATE TABLE [dbo].[ewsWine] (
    [ID]        INT            NOT NULL,
    [Date]      DATETIME       NULL,
    [eRP URL]   NVARCHAR (255) NULL,
    [EWS Score] FLOAT (53)     NULL,
    [EWS Note]  NVARCHAR (MAX) NULL,
    [wineN]     INT            NULL
);

