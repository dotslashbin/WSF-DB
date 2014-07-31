CREATE proc [dbo].autoMatchTry(@whN int) 
as begin
--declare @whN int=-20
/*
autoMatchTryDev 20
*/
set noCount on
declare  @importStatus int = 0,     @sq1 nvarchar(max),     @sq2 nvarchar(max),     @sq3 nvarchar(max)
 
--if @whN=20 return
set @whN=abs(@whN)
 
declare	@id int, @vintage varchar(10), @myWineName varchar(200), @erpWineName varchar(200), @Supplier varchar(max), @PurchaseQuantity varchar(max), @BottleSize	varchar(max)
		,@purchaseDateRaw varchar(100), @deliveryDateRaw varChar(100),  @PurchaseDate datetime, @deliveryDate datetime, @Price varchar(max), @Location varchar(max), @wineNFromMatch int, @myVintage varchar(max), @noMatch bit
		, @supplierN int, @supplierUnknownN int, @BottleCount int, @BottleSizeL float, @BottleSizeN int, @bottleSize750N int, @pricePerBottle int, @wineN int, @wineN2 int
		, @errors nvarchar(max), @errorCnt int=0, @safeWineN int, @safeVinn int, @cntVinn int=0, @vinn int, @vinn2 int;
 
declare @minSmallDateTime smallDateTime = convert(smallDateTime,0), @today date = getDate(), @original varchar(max), @sizeMultiplier int = 1000, @i int
		, @kludgeFlagForOnOrder dateTime=convert(datetime,'Dec 31 9999')
		, @nameMatchedNotVintage int = 0, @nameAndVintageMatched int = 0
		, @rowflag int = 0
		, @flag0 int = 1
		, @flag1 int = 7
		, @flag2 int = 4
		, @flagRed int = 5
		, @totalBottleCount int = 0
		, @count int
		, @autoMatched int = 0
		, @failedAutoVintage int = 0
		, @matchedCnt int = 0
		
	declare @myTableName nvarchar(max) = ' transfer..UserWines'+convert(nvarchar,@whn)
		, @flagSelectedWine int = 7
		, @flagGoodMatch int = 4	--7     --20     --7     --17
		, @flagFromMyHistory int = 1     --19
		, @flagFromOtherHistory int = 10     --24
		, @flagNotThere int = 4
		, @flagClash int = 5
		, @approvedThisCycle int=23
		
	declare @comments nvarchar(max)
		, @commentsYouMatched nvarchar(max)=' <b><small>(You Matched This Before)</small></b>'
		, @commentsOtherVintage nvarchar(max)='<b><small>(Additional  Vintage)</small></b>'
		, @commentsOtherHistory nvarchar(max)='<b><small>(Other Users Matched This)</small></b>'
		, @commentsSelected nvarchar(max)=' <b><small>(The Selected Wine)</small></b> '
		, @commentsSelectedNew nvarchar(max)='<b><small>(The Selected Wine)<br>(New Vintage)</small></b> ';
 
	declare @where nvarchar(max)='', @mp cursor
	declare @cnt int, @matchName nvarchar(999), @matchName2 nvarchar(999), @labelName nvarchar(999), @labelName2 nvarchar(999)
 
	set @sq2 = '
update transfer..userwines'+convert(nvarchar,@whN)+'
	set
	  erpWineName=@matchName
	, temp=@labelName 
	, wineN=@wineN
	, presentBeforeThisCycle=1
	, fromOtherVintage=0
	, rowFlag='+convert(nvarchar,@flagSelectedWine)+'
	, comments=''<b><small>(Auto-Matched)</small></b>''
where id=@id'
			 
	set @sq3 = '
update transfer..userwines'+convert(nvarchar,@whN)+'
	set
	  erpWineName=@matchName
	, temp=@labelName 
	, wineN=@wineN
	, presentBeforeThisCycle=1
	, hasErpTasting=1
	, fromSameVintage=1
	, fromOtherVintage=0
	, rowFlag='+convert(nvarchar,@flagClash )+'
	, comments=''<b><small>(Only wine with an eRP review,<br> but others also match)</small></b>''
where id=@id'
			 
	set @sq1 =  N'Set @mp = cursor for Select Id, Vintage, MyWineName,Supplier, PurchaseQuantity, BottleSize, PurchaseDate, DeliveryDate, Price, Location, wineN, myVintage, NoMatch 
					from transfer..userWines' 
					+ convert(nvarchar, @whN) 
					+ N'  where isDetail=0 and isnull(erpWineName,'''') not like ''%[0-z ]%'' 
					order by myWineName, vintage desc; open @mp';
	exec sp_executeSQL @sq1, N'@mp cursor OUTPUT',  @mp = @mp OUTPUT
 
	select	@bottleSize750N = (select top 1 bottleSizeN from bottleSize where name like '%750%standard%')
			,@supplierUnknownN = (select top 1 supplierN from Supplier where whN = -1 and name like '%(%unknown%)%')
 
	declare @TT table(wineN int, vinn int, vintage nvarchar(5), matchName nvarchar(299), labelName nvarchar(999), hasErpTasting bit)
	declare @priorMyWineName nvarchar(999)=null
	while 1=1
		begin
			fetch next from @mp into @id, @vintage, @myWineName, @Supplier, @PurchaseQuantity, @BottleSize, @PurchaseDateRaw, @DeliveryDateRaw, @Price, @Location, @wineNFromMatch, @myVintage, @noMatch
			if @@fetch_status <> 0 
				begin
					if @priorMyWineName is not null
						if @safeWineN is not null 
							exec dbo.autoOtherVintages @whN, @priorMyWineName, @safeWineN
 
					exec.dbo.autoMismatchBold @whN
					break
				end
			
			if @priorMyWineName is null or @priorMyWineName <>  @myWineName 
				begin
					if @priorMyWineName is not null
						begin
							if @safeWineN is not null 
								exec dbo.autoOtherVintages @whN, @priorMyWineName, @safeWineN
						end
 
					delete from @TT
					insert into @TT(winen, vinn, vintage,matchname, labelName, hasErpTasting )
						select winen, vinn, vintage, matchName, labelName, hasErpTasting  from dbo.getWinesLikeDev(@myWineName)
 
					select @cntVinn=count(distinct vinn) from @TT
					if 1=@cntVinn
						begin
							select top 1 @safeWineN=wineN from @TT
						end
					else
						begin
							select @safeWineN=null, @safeVinn=null
						end
				end
 
			if 1=(select count(*) from @TT where vintage = @vintage )
				begin
					--select top 1 @wineN=wineN, @vinn=vinn, @matchName=matchName, @labelName=labelName from @TT where vintage = @vintage
					select top 1 @wineN=wineN, @vinn=vinn, @matchName=matchName, @labelName=labelName from @TT where vintage = @vintage
					exec sp_executeSQL @sq2, N'@matchName nvarchar(999), @labelName nvarchar(999), @wineN int, @id int',@matchName, @labelName, @wineN, @id
					if @cntVinn=0 
						select @cntVinn=1, @safeVinn=@vinn, @safeWineN=@wineN
					else 
						begin
							if @vinn<>@safeVinn 
								select @cntVinn+=1, @safeWineN=null
						end
				end
			else
				begin
					if 1=(select count(*) from @TT where vintage = @vintage and hasErpTasting=1 )
						begin
							select top 1 @wineN2=wineN, @vinn2=vinn, @matchName2=matchName, @labelName2=labelName  from @TT where vintage = @vintage and hasErpTasting=1
							exec sp_executeSQL @sq3, N'@matchName nvarchar(999), @labelName nvarchar(999), @wineN int, @id int',@matchName2, @labelName2, @wineN2, @id
							--if @cntVinn=0 
								--select @cntVinn=1, @safeVinn=@vinn, @safeWineN=@wineN
							--else 
								--begin
									--if @vinn<>@safeVinn 
										--select @cntVinn+=1, @safeWineN=null
								--end
						end
				end
 
			set @priorMyWineName = @myWineName
		
		end
	close @mp
	deallocate @mp
 end
