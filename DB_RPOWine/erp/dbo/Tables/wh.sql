CREATE TABLE [dbo].[wh] (
    [whN]                          INT            IDENTITY (1, 1) NOT NULL,
    [memberId]                     INT            NULL,
    [tag]                          NVARCHAR (50)  NULL,
    [fullName]                     VARCHAR (300)  NULL,
    [shortName]                    NVARCHAR (50)  NULL,
    [displayName]                  NVARCHAR (200) NULL,
    [sortName]                     NVARCHAR (200) NULL,
    [address]                      NVARCHAR (500) NULL,
    [city]                         NVARCHAR (500) NULL,
    [state]                        NVARCHAR (200) NULL,
    [postalCode]                   NVARCHAR (50)  NULL,
    [country]                      NVARCHAR (200) NULL,
    [phone]                        NVARCHAR (100) NULL,
    [fax]                          NVARCHAR (100) NULL,
    [email]                        NVARCHAR (500) NULL,
    [createWhN]                    INT            NULL,
    [createDate]                   SMALLDATETIME  CONSTRAINT [DF_wh_createDate] DEFAULT (getdate()) NULL,
    [updateWhN]                    INT            NULL,
    [comments]                     VARCHAR (MAX)  NULL,
    [isGroup]                      BIT            CONSTRAINT [DF_wh_isGroup] DEFAULT ((0)) NOT NULL,
    [isLocation]                   BIT            CONSTRAINT [DF_wh_isLocation] DEFAULT ((0)) NOT NULL,
    [isPub]                        BIT            CONSTRAINT [DF_wh_isPublication] DEFAULT ((0)) NOT NULL,
    [iconN]                        SMALLINT       NULL,
    [isProfessionalTaster]         BIT            CONSTRAINT [DF_wh_isProfessionalTaster] DEFAULT ((0)) NOT NULL,
    [isErpMember]                  BIT            CONSTRAINT [DF_wh_isErpMember] DEFAULT ((0)) NOT NULL,
    [isRetailer]                   BIT            CONSTRAINT [DF_wh_isRetailer] DEFAULT ((0)) NOT NULL,
    [isImporter]                   BIT            CONSTRAINT [DF_wh_isImporter] DEFAULT ((0)) NOT NULL,
    [isWinery]                     BIT            CONSTRAINT [DF_wh_isWinery] DEFAULT ((0)) NOT NULL,
    [isWineMaker]                  BIT            CONSTRAINT [DF_wh_isWineMaker] DEFAULT ((0)) NOT NULL,
    [isEditor]                     BIT            CONSTRAINT [DF_wh_isEditor] DEFAULT ((0)) NOT NULL,
    [_bottleWhN]                   INT            NULL,
    [rowVersion]                   ROWVERSION     NULL,
    [isInactive]                   BIT            CONSTRAINT [df_wh_isInactive] DEFAULT ((0)) NULL,
    [isView]                       BIT            CONSTRAINT [df_wh_isView] DEFAULT ((0)) NOT NULL,
    [doIncludeMyTastingsInMyWines] BIT            CONSTRAINT [DF_wh_doIncludeMyTastingsInMyWines] DEFAULT ((1)) NULL,
    [doIncludeMyBottlesInMyWines]  BIT            CONSTRAINT [DF_wh_doIncludeMyBottlesInMyWines] DEFAULT ((1)) NULL,
    [doFlagMyTastingsInMyWines]    BIT            CONSTRAINT [DF_wh_doFlagMyTastingsInMyWines] DEFAULT ((1)) NULL,
    [doFlagMyBottlesInMyWines]     BIT            CONSTRAINT [DF_wh_doFlagMyBottlesInMyWines] DEFAULT ((1)) NULL,
    [descriptionAsTarget]          VARCHAR (300)  NULL,
    [isFake]                       BIT            CONSTRAINT [DF_wh_isFake] DEFAULT ((0)) NOT NULL,
    [handle]                       SMALLINT       NULL,
    [isTasterAsPub]                BIT            CONSTRAINT [DF_isTasterAsPub_isPub] DEFAULT ((0)) NOT NULL,
    [masterPubN]                   INT            NULL,
    [defaultPubN]                  INT            NULL,
    [userName]                     VARCHAR (200)  NULL,
    [ParkerZralyLevel]             TINYINT        CONSTRAINT [DF_wh_ParkerZralyLevel] DEFAULT ((0)) NULL,
    [isNoteLocked]                 BIT            CONSTRAINT [DF_wh_isNoteLocked] DEFAULT ((0)) NULL,
    [isMyWinesLocked]              BIT            CONSTRAINT [DF_wh_isMyWinesLocked] DEFAULT ((0)) NULL,
    [importStatus]                 SMALLINT       NULL,
    [aliasOfWhn]                   INT            NULL,
    CONSTRAINT [PK_who] PRIMARY KEY CLUSTERED ([whN] ASC)
);


GO
CREATE NONCLUSTERED INDEX [DisplayName]
    ON [dbo].[wh]([displayName] ASC)
    INCLUDE([whN]);


GO
CREATE NONCLUSTERED INDEX [IsPublicationSortName]
    ON [dbo].[wh]([isPub] ASC, [sortName] ASC);


GO
CREATE NONCLUSTERED INDEX [IsProfessionalTasterSortName]
    ON [dbo].[wh]([isProfessionalTaster] ASC, [sortName] ASC);


GO
CREATE NONCLUSTERED INDEX [Pk_whTag]
    ON [dbo].[wh]([tag] ASC);


GO
CREATE NONCLUSTERED INDEX [ix_wh_fullName]
    ON [dbo].[wh]([fullName] ASC);

