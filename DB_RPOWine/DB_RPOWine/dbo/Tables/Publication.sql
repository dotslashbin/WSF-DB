CREATE TABLE [dbo].[Publication] (
    [ID]          INT           IDENTITY (1, 1) NOT NULL,
    [PublisherID] INT           NOT NULL,
    [Name]        NVARCHAR (50) NOT NULL,
    [created]     SMALLDATETIME CONSTRAINT [DF_Publication_created] DEFAULT (getdate()) NOT NULL,
    [updated]     SMALLDATETIME NULL,
    CONSTRAINT [PK_Publication] PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [FK_Publication_Publisher] FOREIGN KEY ([PublisherID]) REFERENCES [dbo].[Publisher] ([ID])
);




GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_Publication_Uniq]
    ON [dbo].[Publication]([Name] ASC)
    INCLUDE([ID]);

