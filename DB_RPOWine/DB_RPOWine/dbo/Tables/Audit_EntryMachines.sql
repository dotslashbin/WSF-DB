CREATE TABLE [dbo].[Audit_EntryMachines] (
    [ID]     INT           IDENTITY (1, 1) NOT NULL,
    [Name]   NVARCHAR (50) NOT NULL,
    [DateOp] SMALLDATETIME CONSTRAINT [DF_Audit_EntryMachines_DateOp] DEFAULT (getdate()) NULL,
    CONSTRAINT [PK_Audit_EntryMachines] PRIMARY KEY CLUSTERED ([ID] ASC) ON [AuditLog]
);

