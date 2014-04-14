﻿CREATE TABLE [dbo].[WineName] (
    [idN]                              INT           IDENTITY (1, 1) NOT NULL,
    [ProducerShow]                     VARCHAR (255) NULL,
    [LabelName]                        VARCHAR (255) NULL,
    [Country]                          VARCHAR (255) NULL,
    [Region]                           VARCHAR (255) NULL,
    [Location]                         VARCHAR (255) NULL,
    [Locale]                           VARCHAR (255) NULL,
    [Site]                             VARCHAR (255) NULL,
    [Variety]                          VARCHAR (255) NULL,
    [ColorClass]                       VARCHAR (50)  NULL,
    [WineType]                         VARCHAR (50)  NULL,
    [Dryness]                          VARCHAR (50)  NULL,
    [EncodedKeywords]                  VARCHAR (999) NULL,
    [ReviewerIdN]                      INT           NULL,
    [CntWine]                          INT           NULL,
    [CntHasTasting]                    INT           NULL,
    [CntForSale]                       INT           NULL,
    [CntForSaleAndHasTasting]          INT           NULL,
    [CntVintage]                       INT           NULL,
    [CntVintageHasTasting]             INT           NULL,
    [CntVintageForSale]                INT           NULL,
    [CntVintageForSaleAndHasTasting]   INT           NULL,
    [WJCntWine]                        INT           NULL,
    [WJCntHasTasting]                  INT           NULL,
    [WJCntForSale]                     INT           NULL,
    [WJCntForSaleAndHasTasting]        INT           NULL,
    [WJCntVintage]                     INT           NULL,
    [WjCntVintageHasTasting]           INT           NULL,
    [WJCntVintageForSale]              INT           NULL,
    [WJCntVintageForSaleAndHasTasting] INT           NULL,
    [isMultiCountry]                   BIT           CONSTRAINT [DF_WineName_isMultiCountry] DEFAULT ((0)) NULL,
    [isMultiRegion]                    BIT           CONSTRAINT [DF_WineName_isMultiRegion] DEFAULT ((0)) NULL,
    [isMultiLocation]                  BIT           CONSTRAINT [DF_WineName_isMultiLocation] DEFAULT ((0)) NULL,
    [isMultiLocale]                    BIT           CONSTRAINT [DF_WineName_isMultiLocale] DEFAULT ((0)) NULL,
    [isMultiSite]                      BIT           CONSTRAINT [DF_WineName_isMultiSit] DEFAULT ((0)) NULL,
    [isMultiVariety]                   BIT           CONSTRAINT [DF_WineName_isMultiVintage] DEFAULT ((0)) NULL,
    [isMultiColorClass]                BIT           CONSTRAINT [DF_WineName_isMultiColorClass] DEFAULT ((0)) NULL,
    [isMultiWineType]                  BIT           CONSTRAINT [DF_WineName_isMultiWineType] DEFAULT ((0)) NULL,
    [isMultiDryness]                   BIT           CONSTRAINT [DF_WineName_isMultiDryness] DEFAULT ((0)) NULL,
    CONSTRAINT [PK_WineName] PRIMARY KEY CLUSTERED ([idN] ASC)
);
