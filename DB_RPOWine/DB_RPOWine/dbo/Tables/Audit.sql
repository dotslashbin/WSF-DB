CREATE TABLE [dbo].[Audit] (
    [ID]            INT           IDENTITY (1, 1) NOT NULL,
    [EntryDate]     DATETIME      CONSTRAINT [DF_Audit_EntryDate] DEFAULT (getdate()) NOT NULL,
    [TypeID]        INT           NOT NULL,
    [CategoryID]    INT           NOT NULL,
    [SourceID]      INT           NOT NULL,
    [UserNameID]    INT           NOT NULL,
    [MachineNameID] INT           NOT NULL,
    [ObjectTypeID]  INT           NOT NULL,
    [ObjectID]      VARCHAR (80)  NOT NULL,
    [Description]   VARCHAR (256) NOT NULL,
    [Message]       TEXT          NULL,
    CONSTRAINT [PK_Audit] PRIMARY KEY CLUSTERED ([ID] ASC) ON [AuditLog],
    CONSTRAINT [FK_Audit_Audit_EntryCategories] FOREIGN KEY ([CategoryID]) REFERENCES [dbo].[Audit_EntryCategories] ([ID]),
    CONSTRAINT [FK_Audit_Audit_EntryMachines] FOREIGN KEY ([MachineNameID]) REFERENCES [dbo].[Audit_EntryMachines] ([ID]),
    CONSTRAINT [FK_Audit_Audit_EntrySources] FOREIGN KEY ([SourceID]) REFERENCES [dbo].[Audit_EntrySources] ([ID]),
    CONSTRAINT [FK_Audit_Audit_EntryTypes] FOREIGN KEY ([TypeID]) REFERENCES [dbo].[Audit_EntryTypes] ([ID]),
    CONSTRAINT [FK_Audit_Audit_EntryUsers] FOREIGN KEY ([UserNameID]) REFERENCES [dbo].[Audit_EntryUsers] ([ID]),
    CONSTRAINT [FK_Audit_Audit_ObjectTypes] FOREIGN KEY ([ObjectTypeID]) REFERENCES [dbo].[Audit_ObjectTypes] ([ID])
) TEXTIMAGE_ON [AuditLog];


GO
CREATE NONCLUSTERED INDEX [Audit_GetList]
    ON [dbo].[Audit]([ObjectTypeID] ASC, [ObjectID] ASC, [EntryDate] ASC, [TypeID] ASC, [CategoryID] ASC, [SourceID] ASC, [UserNameID] ASC, [MachineNameID] ASC)
    ON [AuditLog];

