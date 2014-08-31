CREATE TABLE [dbo].[whToCellarArea] (
    [CellarAreaN]    INT            IDENTITY (1, 1) NOT NULL,
    [CellarAreaName] NVARCHAR (200) NOT NULL,
    [whN]            INT            NOT NULL,
    [bottleCnt]      INT            NULL,
    [maxBottleCnt]   INT            NULL,
    [createDate]     SMALLDATETIME  CONSTRAINT [DF_whToCellarArea_created] DEFAULT (getdate()) NULL,
    [rowVerstion]    ROWVERSION     NOT NULL
);

