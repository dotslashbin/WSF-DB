CREATE TABLE [dbo].[tasting] (
    [tastingN]                   INT            IDENTITY (1, 1) NOT NULL,
    [wineN]                      INT            NOT NULL,
    [vinN]                       INT            NULL,
    [wineNameN]                  INT            NULL,
    [pubN]                       INT            NULL,
    [pubDate]                    SMALLDATETIME  NULL,
    [issue]                      VARCHAR (50)   NULL,
    [pages]                      VARCHAR (50)   NULL,
    [articleId]                  SMALLINT       NULL,
    [_x_articleIdNKey]           INT            NULL,
    [articleOrder]               SMALLINT       NULL,
    [articleURL]                 VARCHAR (500)  NULL,
    [notes]                      VARCHAR (MAX)  NULL,
    [tasterN]                    INT            NULL,
    [tasteDate]                  SMALLDATETIME  NULL,
    [isMostRecentTasting]        BIT            NULL,
    [isNoTasting]                BIT            NULL,
    [isActiveForThisPub]         BIT            NULL,
    [_x_IsActiveWineN]           BIT            NULL,
    [isBorrowedDrinkDate]        BIT            NULL,
    [IsBarrelTasting]            BIT            NULL,
    [bottleSizeN]                SMALLINT       NULL,
    [rating]                     TINYINT        NULL,
    [ratingPlus]                 BIT            NULL,
    [ratingHi]                   TINYINT        NULL,
    [ratingShow]                 VARCHAR (50)   NULL,
    [drinkDate]                  DATETIME       NULL,
    [drinkDateHi]                DATETIME       NULL,
    [drinkWhenN]                 SMALLINT       NULL,
    [maturityN]                  SMALLINT       NULL,
    [estimatedCostLo]            MONEY          NULL,
    [estimatedCostHi]            MONEY          NULL,
    [originalCurrencyN]          SMALLINT       NULL,
    [provenanceN]                SMALLINT       NULL,
    [whereTastedN]               SMALLINT       NULL,
    [isAvailabeToTastersGroups]  BIT            NULL,
    [isPostedToBB]               BIT            NULL,
    [isAnnonymous]               BIT            CONSTRAINT [DF_tasting_isAnnonymous] DEFAULT ((0)) NULL,
    [isPrivate]                  BIT            CONSTRAINT [DF_tasting_isPrivate] DEFAULT ((0)) NULL,
    [updateWhN]                  INT            NULL,
    [_clumpName]                 VARCHAR (500)  NULL,
    [_fixedId]                   INT            NULL,
    [_x_hasAGalloniTasting]      BIT            NULL,
    [_x_HasCurrentPrice]         BIT            NULL,
    [_x_hasDSchildknechtTasting] BIT            NULL,
    [_x_hasDThomasesTasting]     BIT            NULL,
    [_x_hasErpTasting]           BIT            NULL,
    [_x_hasJMillerTasting]       BIT            NULL,
    [_x_hasMSquiresTasting]      BIT            NULL,
    [_x_hasMultipleWATastings]   BIT            NULL,
    [_x_hasNMartinTasting]       BIT            NULL,
    [_x_hasProducerProfile]      BIT            NULL,
    [_x_HasProducerWebSite]      BIT            NULL,
    [_x_hasPRovaniTasting]       BIT            NULL,
    [_x_hasRParkerTasting]       BIT            NULL,
    [_x_hasWJtasting]            BIT            NULL,
    [_x_reviewerIdN]             INT            NULL,
    [ratingQ]                    NVARCHAR (MAX) NULL,
    [createDate]                 SMALLDATETIME  CONSTRAINT [DF_tasting_createDate] DEFAULT (getdate()) NULL,
    [createWh]                   INT            NULL,
    [rowversion]                 ROWVERSION     NOT NULL,
    [isInactive]                 BIT            CONSTRAINT [df_tasting_isInactive] DEFAULT ((0)) NULL,
    [articleMasterN]             INT            NULL,
    [decantedN]                  SMALLINT       NULL,
    [isApproved]                 BIT            CONSTRAINT [DF_tasting_isApproved] DEFAULT ((0)) NULL,
    [hasUserComplaint]           BIT            NULL,
    [updateDate]                 SMALLDATETIME  NULL,
    [hasHad]                     NCHAR (10)     NULL,
    [userComplaintCount]         SMALLINT       CONSTRAINT [DF_tasting_userComplaintCount] DEFAULT ((0)) NULL,
    [hasRating]                  BIT            NULL,
    [isErpTasting]               BIT            NULL,
    [ParkerZralyLevel]           TINYINT        NULL,
    [sourceIconN]                TINYINT        NULL,
    [isProTasting]               BIT            CONSTRAINT [DF_tasting_isProTasting] DEFAULT ((0)) NULL,
    [canBeActiveTasting]         BIT            NULL,
    [_x_showForERP]              BIT            NULL,
    [_x_showForWJ]               BIT            NULL,
    [_fixedIdDeleted]            BIT            NULL,
    [dataIdN]                    INT            NULL,
    [dataIdNDeleted]             INT            NULL,
    [dataSourceN]                INT            NULL,
    [isActive]                   BIT            NULL,
    [hasRating2]                 AS             (case when [rating]>(0) then (1) else (0) end) PERSISTED NOT NULL,
    [isWA]                       AS             (case when [pubN]=(9) OR [pubN]=(8) OR [pubN]=(5) OR [pubN]=(4) OR [pubN]=(3) OR [pubN]=(2) OR [pubN]=(1) then (1) else (0) end) PERSISTED NOT NULL,
    [isWaActive]                 BIT            NULL,
    [isErpPro]                   AS             (case when [pubN]=(18286) OR [pubN]=(18281) OR [pubN]=(18223) OR [pubN]=(9) OR [pubN]=(8) OR [pubN]=(6) OR [pubN]=(5) OR [pubN]=(4) OR [pubN]=(3) OR [pubN]=(2) OR [pubN]=(1) then (1) else (0) end) PERSISTED NOT NULL,
    [isErpProActive]             BIT            NULL,
    [handle]                     INT            NULL,
    [isDisapproved]              BIT            NULL,
    CONSTRAINT [PK_Tasting] PRIMARY KEY CLUSTERED ([tastingN] ASC)
);


GO
CREATE NONCLUSTERED INDEX [k_tasting_PubNWineN]
    ON [dbo].[tasting]([pubN] ASC, [wineN] ASC);


GO
CREATE NONCLUSTERED INDEX [k_tasting_tasterNWineN]
    ON [dbo].[tasting]([tasterN] ASC, [wineN] ASC);


GO
CREATE NONCLUSTERED INDEX [k_tasting_wineN]
    ON [dbo].[tasting]([wineN] ASC);


GO
CREATE NONCLUSTERED INDEX [k_tasting_winenameN]
    ON [dbo].[tasting]([wineNameN] ASC);


GO
CREATE NONCLUSTERED INDEX [k_tasting_pubN_issue]
    ON [dbo].[tasting]([pubN] ASC, [issue] ASC, [articleId] ASC);


GO
CREATE UNIQUE NONCLUSTERED INDEX [ix_Tasting_allActiveFields]
    ON [dbo].[tasting]([wineN] ASC, [hasRating] DESC, [isErpTasting] DESC, [ParkerZralyLevel] DESC, [tasteDate] DESC, [tastingN] ASC, [rating] ASC, [maturityN] ASC);


GO
CREATE NONCLUSTERED INDEX [ix_tasting_activeWine]
    ON [dbo].[tasting]([wineN] ASC, [hasRating] DESC, [isErpTasting] DESC, [isProTasting] DESC, [ParkerZralyLevel] DESC, [tasteDate] DESC, [tastingN] ASC);


GO
CREATE NONCLUSTERED INDEX [ix_tasting_isActive]
    ON [dbo].[tasting]([isActive] ASC) WHERE ([isActive]=(1));


GO
CREATE NONCLUSTERED INDEX [ix_tasting_iswa]
    ON [dbo].[tasting]([isWA] ASC) WHERE ([pubN] IN ((1), (2), (3), (4), (5), (8), (9)));


GO
CREATE NONCLUSTERED INDEX [ix_tasting_isWaActive]
    ON [dbo].[tasting]([isWaActive] ASC) WHERE ([isWaActive]=(1));


GO
CREATE NONCLUSTERED INDEX [ix_tasting_isErpPro]
    ON [dbo].[tasting]([isErpPro] ASC) WHERE ([pubN] IN ((1), (2), (3), (4), (5), (6), (8), (9), (18223), (18281), (18286)));


GO
CREATE NONCLUSTERED INDEX [ix_tasting_isErpProActive]
    ON [dbo].[tasting]([isErpProActive] ASC) WHERE ([isErpProActive]=(1));


GO
CREATE NONCLUSTERED INDEX [ix_tasting_activeWine2]
    ON [dbo].[tasting]([wineN] ASC, [hasRating2] DESC, [isWA] DESC, [isErpPro] DESC, [ParkerZralyLevel] DESC, [tasteDate] DESC, [tastingN] ASC);


GO
CREATE NONCLUSTERED INDEX [ix_tasting_wineNtasteDateUpdateDate8]
    ON [dbo].[tasting]([wineN] ASC, [tasteDate] DESC, [updateDate] DESC);


GO
CREATE trigger [dbo].[tasting_WineNUpdate] on [dbo].[tasting]
after insert, update
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
		if UPDATE(wineN) begin
		
			insert into whToWine(whN,wineN,isDerived,isOfInterest)
				select a.tasterN, a.wineN, 1,1
					from (select tasterN, wineN	
								from inserted
								group by tasterN, wineN
							) a
						left join	
							(select whN, wineN
								from whToWine
								group by whN, wineN
								) b
						on a.tasterN = b.whN and a.wineN = b.wineN
					where
						a.tasterN is not null 
						and a.wineN is not null 
						and 
							(b.whN is null 
							or b.wineN is null
							)

			update a
				set a.wineNameN = b.wineNameN
					, a.vinn = b.activeVinn
				from tasting a
					join wine b
						on a.wineN = b.wineN
				where a.tastingN in (select tastingN from inserted)
 
			update a
				set tastingCount = isnull(b.tastingCount, 0)
				from
					whToWine a
						left join 
							(select tasterN, wineN, count(*) tastingCount
								from tasting
								group by tasterN, wineN
								) b
							on b.tasterN = a.whN
								and b.wineN = a.wineN 
						join 
							inserted c
							on a.whN = c.tasterN
								and a.wineN = c.wineN			
					where
						a.tastingCount is null or (a.tastingCount <> isnull(b.tastingCount, 0))
 
		end
END


GO
CREATE TRIGGER [dbo].[tasting_calcTasting] on [dbo].[tasting]
   AFTER INSERT,UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
 
	--exec dbo.calcTasting (select tastingN from inserted)
 
	update a 
		set
			  hasRating = case when a.rating is not null then 1 else 0 end
			, isErpTasting = dbo.isErpPub(a.pubN)
			, isProTasting = b.isProfessionalTaster
			, parkerZralyLevel = isNull(b.parkerZralyLevel, 0)
			, sourceIconN =	case when c.iconN in (1,2) 
						then c.iconN
						else case b.parkerZralyLevel when 1 then 10 when 2 then 11 when 3 then 12 else null end
						end
			, ratingShow = case when d.isBarrelTasting = 1 then '(' + convert(varchar, d.rating) + isNull(d.ratingQ,'') + case when d.ratingHi is null then '' else '-' + convert(varchar, d.ratingHi) end + ')' else convert(varchar, d.rating) + isNull(d.ratingQ,'') + case when d.ratingHi is null then '' else '-' + convert(varchar, d.ratingHi) end end
			, updateDate = getDate()
		from tasting a
			join inserted d
				on a.tastingN = d.tastingN
			left join wh b
				on a.tasterN = b.whn
			left join wh c
				on a.pubN = c.whn
 
 
END
 
