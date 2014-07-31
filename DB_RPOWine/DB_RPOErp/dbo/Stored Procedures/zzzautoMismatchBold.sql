CREATE proc [dbo].[zzzautoMismatchBold](@whN int) as begin
--declare @whN int=20
/*
exec dbo.zzzautoMismatchBold 20
*/
declare
	@LBold nvarchar(max)='<|>'
	,@RBold nvarchar(max)='</|>'
	,@flagClash int = 5;
	
declare @sq nvarchar(max)='
with
a1 as	(	
	select myWineName,erpWineName,comments,rowflag
		,isNull(matchName,'''')     matchName
		,isNull(labelName,'''')     labelName
		from transfer..userWines20 a
			join vWinePlus b on a.wineN=b.wineN
		where isDetail=0
		)
,a2 as	(	
	select myWineName,erpWineName,comments,rowflag	,matchName,labelName
			,charIndex(labelName,matchName) xindex
			,len(labelName) xlen
			,left(matchName,charIndex(labelName,matchName)+len(labelName)) shortName
		from a1
		)
,b as	(
	select myWineName,erpWineName,comments,rowflag	,matchName,labelName
		,(dbo.keywordsDifQ(myWineName,left(matchName,xindex+xlen),@LBold,@RBold)+substring(matchName,xindex+xlen+1,9999))               erpWineNameBold
		from a2 where xindex>0
	)
,c1 as	(
	select myWineName,erpWineName,comments,rowflag	,matchName,labelName
		, rtrim(replace(erpWineNameBold, (@RBold+'' ''+@LBold),'' '')) erpWineNameBold
	from b
	)
,c2 as	(
	select myWineName,erpWineName,comments,rowflag	,matchName,labelName
		, replace(erpWineNameBold, @RBold,''</span>'') erpWineNameBold
	from c1
	)
,c3 as	(
	select myWineName,erpWineName,comments,rowflag	,matchName,labelName
		--, replace(erpWineNameBold, @LBold,''<span style="color:red; font-style:italic; font-weight:bold;font-size:smaller">'') erpWineNameBold
		, replace(erpWineNameBold, @LBold,''<span style="color:red; font-style:italic">'') erpWineNameBold
	from c2
	)
,c4 as	(
	select myWineName,erpWineName,comments,rowflag	,matchName,labelName
		,case when rowFlag=@flagClash
			then replace(erpWineNameBold, ''color:red'',''color:yellow'')
			else erpWineNameBold
			end	 erpWineNameBold
	from c3
	)
,c5 as	(
	select myWineName,erpWineName,comments,rowflag,matchName,labelName,erpWineNameBold
		, replace(comments
			--,''Matched)''
			--,''Matched, but with discrepencies)''
			,''(Auto-Matched)''
			,''(Partially Auto-Matched)''
			) commentsBold
	from c4
		where matchName<>erpWineNameBold
		)
update c5 set 	erpWineName=erpWineNameBold, comments=commentsBold
'

set @sq=replace(@sq,'@whN',@whN)
set @sq=replace(@sq,'@LBold',''''+@LBold+'''')
set @sq=replace(@sq,'@RBold',''''+@RBold+'''')
set @sq=replace(@sq,'@flagClash',@flagClash)
--print @sq
exec (@sq)
end
