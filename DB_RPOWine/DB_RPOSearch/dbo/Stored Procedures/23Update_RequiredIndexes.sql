CREATE PROCEDURE [23Update_RequiredIndexes]

AS
set nocount on

CREATE NONCLUSTERED INDEX [IX_ForSaleDetail_BottleSize]
    ON [dbo].[ForSaleDetail]([BottleSize] ASC);
CREATE NONCLUSTERED INDEX [IX_ForSaleDetail_Currency]
    ON [dbo].[ForSaleDetail]([Currency] ASC)
    INCLUDE([IdN], [BottleSize], [Price]);
CREATE NONCLUSTERED INDEX [IX_ForSaleDetail_DollarsPer750Bottle]
    ON [dbo].[ForSaleDetail]([DollarsPer750Bottle] ASC)
    INCLUDE([IdN], [Errors]);
CREATE NONCLUSTERED INDEX [IX_ForSaleDetail_Price]
    ON [dbo].[ForSaleDetail]([Price] ASC)
    INCLUDE([IdN], [Errors]);
CREATE NONCLUSTERED INDEX [IX_ForSaleDetail_Wid]
    ON [dbo].[ForSaleDetail]([Wid] ASC)
    INCLUDE([IdN]);
CREATE NONCLUSTERED INDEX [IX_WAName_VinN]
    ON [dbo].[WAName]([VinN] ASC)
    INCLUDE([idN], [Region], [Location], [Variety]);
CREATE NONCLUSTERED INDEX [IX_WAName_VinNColorClass]
    ON [dbo].[WAName]([VinN] ASC, [ColorClass] ASC);
CREATE NONCLUSTERED INDEX [IX_WAName_VinNDryness]
    ON [dbo].[WAName]([VinN] ASC, [Dryness] ASC);
CREATE NONCLUSTERED INDEX [IX_WAName_VinNProducer]
    ON [dbo].[WAName]([VinN] ASC, [Producer] ASC);
CREATE NONCLUSTERED INDEX [IX_WAName_VinNVariety]
    ON [dbo].[WAName]([VinN] ASC, [Variety] ASC);
CREATE NONCLUSTERED INDEX [IX_WAName_VinNWineType]
    ON [dbo].[WAName]([VinN] ASC, [WineType] ASC);
CREATE NONCLUSTERED INDEX [IX_WAName_Wid]
    ON [dbo].[WAName]([Wid] ASC)
    INCLUDE([idN]);
CREATE NONCLUSTERED INDEX [IX_ForSaleDetail_RetailerCode] ON [dbo].[ForSaleDetail] 
(
	[RetailerCode] ASC
)
INCLUDE ( [IdN]) WITH (STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]


RETURN 1