CREATE TABLE [dbo].[Audit_ObjectTypes] (
    [ID]     INT           IDENTITY (1, 1) NOT NULL,
    [Name]   NVARCHAR (50) NOT NULL,
    [DateOp] SMALLDATETIME CONSTRAINT [DF_Audit_ObjectTypes_DateOp] DEFAULT (getdate()) NULL,
    CONSTRAINT [PK_Audit_ObjectTypes] PRIMARY KEY CLUSTERED ([ID] ASC) ON [AuditLog]
);

