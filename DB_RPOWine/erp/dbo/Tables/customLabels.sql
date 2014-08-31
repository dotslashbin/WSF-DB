CREATE TABLE [dbo].[customLabels] (
    [id]          INT      IDENTITY (1, 1) NOT NULL,
    [whn]         INT      NOT NULL,
    [wineN]       INT      NOT NULL,
    [picture]     IMAGE    NOT NULL,
    [dateCreated] DATETIME NOT NULL
);

