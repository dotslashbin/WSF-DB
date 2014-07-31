﻿CREATE TABLE [dbo].[aaNameChange] (
    [whN]         INT            NOT NULL,
    [memberId]    INT            NULL,
    [producer]    NVARCHAR (100) NOT NULL,
    [producer2]   NVARCHAR (255) NULL,
    [labelName]   NVARCHAR (150) NULL,
    [labelName2]  NVARCHAR (255) NULL,
    [colorClass]  NVARCHAR (20)  NULL,
    [colorClass2] NVARCHAR (255) NULL,
    [variety]     NVARCHAR (100) NULL,
    [variety2]    NVARCHAR (255) NULL,
    [country]     NVARCHAR (100) NULL,
    [country2]    NVARCHAR (255) NULL,
    [region]      NVARCHAR (100) NULL,
    [region2]     NVARCHAR (255) NULL,
    [location]    NVARCHAR (100) NULL,
    [location2]   NVARCHAR (255) NULL,
    [locale]      NVARCHAR (100) NULL,
    [locale2]     NVARCHAR (255) NULL
);

