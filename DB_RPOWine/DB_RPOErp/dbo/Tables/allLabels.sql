CREATE TABLE [dbo].[allLabels] (
    [id]            INT          IDENTITY (1, 1) NOT NULL,
    [picture]       IMAGE        NOT NULL,
    [wineN]         INT          NOT NULL,
    [whN]           INT          NOT NULL,
    [dateCreated]   DATETIME     NOT NULL,
    [dateApproved]  DATETIME     NULL,
    [isApproved]    BIT          NOT NULL,
    [whoApproved]   VARCHAR (50) NULL,
    [vinN]          INT          NULL,
    [userId]        INT          NULL,
    [isDisApproved] BIT          NULL
);

