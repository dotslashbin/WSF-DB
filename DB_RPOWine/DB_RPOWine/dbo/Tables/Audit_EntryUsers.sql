CREATE TABLE [dbo].[Audit_EntryUsers] (
    [ID]     INT           IDENTITY (1, 1) NOT NULL,
    [Name]   NVARCHAR (50) NOT NULL,
    [DateOp] SMALLDATETIME CONSTRAINT [DF_Audit_EntryUsers_DateOp] DEFAULT (getdate()) NULL,
    [Flag]   SMALLINT      DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_Audit_EntryUsers] PRIMARY KEY CLUSTERED ([ID] ASC) ON [AuditLog]
);

