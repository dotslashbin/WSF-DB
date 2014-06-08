CREATE TABLE [dbo].[WAName] (
    [idN]                       INT            IDENTITY (1, 1) NOT NULL,
    [Wid]                       NVARCHAR (50)  CONSTRAINT [DF_WAName_Wid] DEFAULT (NULL) NULL,
    [VinN]                      INT            CONSTRAINT [DF_WAName_VinN] DEFAULT (NULL) NULL,
    [isTempVinn]                BIT            NULL,
    [IsVinnDeduced]             BIT            CONSTRAINT [DF_WAName_IsVinnDeduced] DEFAULT ((0)) NOT NULL,
    [Producer]                  NVARCHAR (255) CONSTRAINT [DF_WAName_Producer] DEFAULT (NULL) NULL,
    [ProducerShow]              NVARCHAR (255) CONSTRAINT [DF_WAName_ProducerShow] DEFAULT (NULL) NULL,
    [erpProducer]               NVARCHAR (255) NULL,
    [erpProducerShow]           NVARCHAR (255) NULL,
    [isVinnProducerAmbiguous]   BIT            CONSTRAINT [DF_WAName_isVinnProducerAmbiguous] DEFAULT ((0)) NOT NULL,
    [isErpProducerOK]           BIT            CONSTRAINT [DF_WAName_isProducerERP] DEFAULT ((0)) NOT NULL,
    [isProducerTranslated]      BIT            CONSTRAINT [DF_WAName_isProducerTranslated] DEFAULT ((0)) NOT NULL,
    [LabelName]                 NVARCHAR (999) CONSTRAINT [DF_WAName_LabelName] DEFAULT (NULL) NULL,
    [erpLabelName]              NVARCHAR (255) NULL,
    [isVinnLabelNameAmbiguous]  BIT            CONSTRAINT [DF_WAName_isVinnRegionAmbiguous1] DEFAULT ((0)) NOT NULL,
    [isErpLabelNameOK]          BIT            CONSTRAINT [DF_WAName_isRegionDeduced1] DEFAULT ((0)) NOT NULL,
    [isLabelNameTranslated]     BIT            CONSTRAINT [DF_WAName_isRegionTranslated1] DEFAULT ((0)) NOT NULL,
    [Variety]                   NVARCHAR (255) CONSTRAINT [DF_WAName_Variety] DEFAULT (NULL) NULL,
    [erpVariety]                NVARCHAR (255) NULL,
    [isVinnVarietyAmbiguous]    BIT            CONSTRAINT [DF_WAName_isVinnVarietyAmbiguous] DEFAULT ((0)) NOT NULL,
    [isErpVarietyOK]            BIT            CONSTRAINT [DF_WAName_isVarietyDeduced] DEFAULT ((0)) NOT NULL,
    [isVarietyTranslated]       BIT            CONSTRAINT [DF_WAName_isVarietyTranslated] DEFAULT ((0)) NOT NULL,
    [ColorClass]                NVARCHAR (255) CONSTRAINT [DF_WAName_ColorClass] DEFAULT (NULL) NULL,
    [erpColorClass]             NVARCHAR (255) NULL,
    [isVinnColorClassAmbiguous] BIT            CONSTRAINT [DF_WAName_isVinnColorClassAmbiguous] DEFAULT ((0)) NOT NULL,
    [isErpColorClassOK]         BIT            CONSTRAINT [DF_WAName_isColorClassDeduced] DEFAULT ((0)) NOT NULL,
    [isColorClassTranslated]    BIT            CONSTRAINT [DF_WAName_isColorClassTranslated] DEFAULT ((0)) NOT NULL,
    [Dryness]                   NVARCHAR (255) CONSTRAINT [DF_WAName_Dryness] DEFAULT (NULL) NULL,
    [erpDryness]                NVARCHAR (255) NULL,
    [isVinnDrynessAmbiguous]    BIT            CONSTRAINT [DF_WAName_isVinnDrynessAmbiguous] DEFAULT ((0)) NOT NULL,
    [isErpDrynessOK]            BIT            CONSTRAINT [DF_WAName_isDrynessDeduced] DEFAULT ((0)) NOT NULL,
    [isDrynessTranslated]       BIT            CONSTRAINT [DF_WAName_isDrynessTranslated] DEFAULT ((0)) NOT NULL,
    [WineType]                  NVARCHAR (255) CONSTRAINT [DF_WAName_WineType] DEFAULT (NULL) NULL,
    [erpWineType]               NVARCHAR (255) NULL,
    [isVinnWineTypeAmbiguous]   BIT            CONSTRAINT [DF_WAName_isVinnWineTypeAmbiguous] DEFAULT ((0)) NOT NULL,
    [isErpWineTypeOK]           BIT            CONSTRAINT [DF_WAName_isWineTypeDeduced] DEFAULT ((0)) NOT NULL,
    [isWineTypeTranslated]      BIT            CONSTRAINT [DF_WAName_isWineTypeTranslated] DEFAULT ((0)) NOT NULL,
    [Country]                   NVARCHAR (255) CONSTRAINT [DF_WAName_Country] DEFAULT (NULL) NULL,
    [erpCountry]                NVARCHAR (255) NULL,
    [isVinnCountryAmbiguous]    BIT            CONSTRAINT [DF_WAName_isVinnCountryAmbiguous] DEFAULT ((0)) NOT NULL,
    [isErpCountryOK]            BIT            CONSTRAINT [DF_WAName_isCountryDeduced] DEFAULT ((0)) NOT NULL,
    [isCountryTranslated]       BIT            CONSTRAINT [DF_WAName_isCountryTranslated] DEFAULT ((0)) NOT NULL,
    [Region]                    NVARCHAR (255) CONSTRAINT [DF_WAName_Region] DEFAULT (NULL) NULL,
    [erpRegion]                 NVARCHAR (255) NULL,
    [isVinnRegionAmbiguous]     BIT            CONSTRAINT [DF_WAName_isVinnRegionAmbiguous] DEFAULT ((0)) NOT NULL,
    [isErpRegionOK]             BIT            CONSTRAINT [DF_WAName_isRegionDeduced] DEFAULT ((0)) NOT NULL,
    [isRegionTranslated]        BIT            CONSTRAINT [DF_WAName_isRegionTranslated] DEFAULT ((0)) NOT NULL,
    [Location]                  NVARCHAR (255) CONSTRAINT [DF_WAName_Location] DEFAULT (NULL) NULL,
    [erpLocation]               NVARCHAR (255) NULL,
    [isVinnLocationAmbiguous]   BIT            CONSTRAINT [DF_WAName_isVinnLocationAmbiguous] DEFAULT ((0)) NOT NULL,
    [isErpLocationOK]           BIT            CONSTRAINT [DF_WAName_isLocationDeduced] DEFAULT ((0)) NOT NULL,
    [isLocationTranslated]      BIT            CONSTRAINT [DF_WAName_isLocationTranslated] DEFAULT ((0)) NOT NULL,
    [Errors]                    NVARCHAR (MAX) CONSTRAINT [DF_WAName_Errors] DEFAULT (NULL) NULL,
    [Warnings]                  NVARCHAR (MAX) NULL,
    [ErrorsOnReadin]            NVARCHAR (MAX) NULL,
    [Wine_VinN_ID]              INT            NULL,
    CONSTRAINT [PK_WAName] PRIMARY KEY CLUSTERED ([idN] ASC)
);






GO
CREATE NONCLUSTERED INDEX [IX_WAName_VinNWineType]
    ON [dbo].[WAName]([VinN] ASC, [WineType] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_WAName_VinNVariety]
    ON [dbo].[WAName]([VinN] ASC, [Variety] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_WAName_VinNProducer]
    ON [dbo].[WAName]([VinN] ASC, [Producer] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_WAName_VinNDryness]
    ON [dbo].[WAName]([VinN] ASC, [Dryness] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_WAName_VinNColorClass]
    ON [dbo].[WAName]([VinN] ASC, [ColorClass] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_WAName_VinN]
    ON [dbo].[WAName]([VinN] ASC)
    INCLUDE([idN], [Region], [Location], [Variety]);


GO
CREATE NONCLUSTERED INDEX [IX_WAName_Wid]
    ON [dbo].[WAName]([Wid] ASC)
    INCLUDE([idN]);

