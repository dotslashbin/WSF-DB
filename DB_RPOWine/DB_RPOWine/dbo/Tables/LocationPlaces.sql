CREATE TABLE [dbo].[LocationPlaces] (
    [ID]          INT            IDENTITY (0, 1) NOT NULL,
    [Name]        NVARCHAR (150) NOT NULL,
    [created]     SMALLDATETIME  CONSTRAINT [DF_LocationPlaces_created] DEFAULT (getdate()) NOT NULL,
    [updated]     SMALLDATETIME  NULL,
    [WF_StatusID] SMALLINT       CONSTRAINT [DF_LocationPlaces_WF_StatusID] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_LocationPlaces] PRIMARY KEY CLUSTERED ([ID] ASC)
);

