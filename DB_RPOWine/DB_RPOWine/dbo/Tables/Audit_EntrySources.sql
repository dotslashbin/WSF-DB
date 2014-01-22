CREATE TABLE [dbo].[Audit_EntrySources] (
    [ID]     INT           IDENTITY (1, 1) NOT NULL,
    [Name]   NVARCHAR (50) NOT NULL,
    [DateOp] SMALLDATETIME CONSTRAINT [DF_Audit_EntrySources_DateOp] DEFAULT (getdate()) NULL,
    CONSTRAINT [PK_Audit_EntrySources] PRIMARY KEY CLUSTERED ([ID] ASC) ON [AuditLog]
);

