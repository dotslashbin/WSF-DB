CREATE TABLE [dbo].[WF_ObjectTypes] (
    [ID]     INT           IDENTITY (1, 1) NOT NULL,
    [Name]   VARCHAR (50)  NOT NULL,
    [DateOp] SMALLDATETIME CONSTRAINT [DF_WF_ObjectTypes_DateOp] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_WF_ObjectTypes] PRIMARY KEY CLUSTERED ([ID] ASC) ON [WF]
);




GO
CREATE UNIQUE NONCLUSTERED INDEX [WF_ObjectTyoes_Uniq]
    ON [dbo].[WF_ObjectTypes]([Name] ASC)
    ON [WF];

