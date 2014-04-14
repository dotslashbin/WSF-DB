CREATE TABLE [dbo].[DatabaseStats] (
    [idN]                   INT           IDENTITY (1, 1) NOT NULL,
    [date]                  DATETIME      NULL,
    [action]                NVARCHAR (50) NULL,
    [forSaleCnt]            INT           NULL,
    [forSaleDetailCnt]      INT           NULL,
    [retailerCnt]           INT           NULL,
    [waNameCnt]             INT           NULL,
    [wineCnt]               INT           NULL,
    [wineNameCnt]           INT           NULL,
    [rpoWineCnt]            INT           NULL,
    [forSaleErrorCnt]       INT           NULL,
    [forSaleDetailErrorCnt] INT           NULL,
    [retailerErrorCnt]      INT           NULL,
    [waNameErrorCnt]        INT           NULL
);

