CREATE TABLE [dbo].[TasteNote] (
    [ID]               INT            IDENTITY (1, 1) NOT NULL,
    [ReviewerID]       INT            NOT NULL,
    [Wine_N_ID]        INT            NOT NULL,
    [__ProducerNoteID] INT            NULL,
    [TasteDate]        DATE           NULL,
    [MaturityID]       SMALLINT       NOT NULL,
    [Rating_Lo]        SMALLINT       NULL,
    [Rating_Hi]        SMALLINT       NULL,
    [DrinkDate_Lo]     DATE           NULL,
    [DrinkDate_Hi]     DATE           NULL,
    [IsBarrelTasting]  BIT            CONSTRAINT [DF_TasteNotes_IsBarrelTasting] DEFAULT ((0)) NOT NULL,
    [oldIdn]           INT            NULL,
    [Notes]            NVARCHAR (MAX) NULL,
    [created]          SMALLDATETIME  CONSTRAINT [DF_TasteNote_created] DEFAULT (getdate()) NOT NULL,
    [updated]          SMALLDATETIME  NULL,
    [WF_StatusID]      SMALLINT       CONSTRAINT [DF_TasteNote_WF_StatusID] DEFAULT ((0)) NOT NULL,
    [PublicationDate]  DATE           NULL,
    [OriginID]         INT            NULL,
    CONSTRAINT [PK_TasteNote] PRIMARY KEY CLUSTERED ([ID] ASC) ON [TasteNotes],
    CONSTRAINT [FK_TasteNote_Reviewer] FOREIGN KEY ([ReviewerID]) REFERENCES [dbo].[Reviewer] ([ID]),
    CONSTRAINT [FK_TasteNote_Wine_N] FOREIGN KEY ([Wine_N_ID]) REFERENCES [dbo].[Wine_N] ([ID]),
    CONSTRAINT [FK_TasteNote_WineMaturity] FOREIGN KEY ([MaturityID]) REFERENCES [dbo].[WineMaturity] ([ID])
) TEXTIMAGE_ON [TasteNotes];





