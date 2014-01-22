CREATE TABLE [dbo].[Audit_EntryCategories] (
    [ID]     INT           IDENTITY (1, 1) NOT NULL,
    [Name]   NVARCHAR (50) NOT NULL,
    [DateOp] SMALLDATETIME CONSTRAINT [DF_Audit_EntryCategories_DateOp] DEFAULT (getdate()) NULL,
    CONSTRAINT [PK_Audit_EntryCategories] PRIMARY KEY CLUSTERED ([ID] ASC) ON [AuditLog]
);

