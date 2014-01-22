CREATE TABLE [dbo].[Audit_EntryTypes] (
    [ID]     INT           IDENTITY (1, 1) NOT NULL,
    [Name]   NVARCHAR (50) NOT NULL,
    [DateOp] SMALLDATETIME CONSTRAINT [DF_Audit_EntryTypes_DateOp] DEFAULT (getdate()) NULL,
    CONSTRAINT [PK_Audit_EntryTypes] PRIMARY KEY CLUSTERED ([ID] ASC) ON [AuditLog]
);

