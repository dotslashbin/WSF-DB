CREATE TABLE [dbo].[Publisher] (
    [ID]        INT           IDENTITY (0, 1) NOT NULL,
    [Name]      NVARCHAR (50) NOT NULL,
    [IsPrimary] BIT           CONSTRAINT [DF_Publisher_IsPrimary] DEFAULT ((0)) NOT NULL,
    [created]   SMALLDATETIME CONSTRAINT [DF_Publisher_created] DEFAULT (getdate()) NOT NULL,
    [updated]   SMALLDATETIME NULL,
    CONSTRAINT [PK_Publisher] PRIMARY KEY CLUSTERED ([ID] ASC)
);




GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_Publisher_Uniq]
    ON [dbo].[Publisher]([Name] ASC)
    INCLUDE([ID]);

