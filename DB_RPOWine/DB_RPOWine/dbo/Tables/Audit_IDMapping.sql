CREATE TABLE [dbo].[Audit_IDMapping] (
    [ID]           INT           IDENTITY (1, 1) NOT NULL,
    [ObjectTypeID] INT           NOT NULL,
    [OldObjectID]  VARCHAR (80)  NOT NULL,
    [NewObjectID]  VARCHAR (80)  NOT NULL,
    [DateOp]       SMALLDATETIME CONSTRAINT [DF_Audit_IDMapping_DateOp] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_Audit_IDMapping] PRIMARY KEY CLUSTERED ([ID] ASC) ON [AuditLog],
    CONSTRAINT [IX_Audit_IDMapping] UNIQUE NONCLUSTERED ([ObjectTypeID] ASC, [OldObjectID] ASC) ON [AuditLog]
);

