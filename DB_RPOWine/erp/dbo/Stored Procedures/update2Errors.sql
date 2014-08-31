
CREATE proc [dbo].[update2Errors] (@ignoreWidMap bit=null)
as begin
set nocount on;
 
declare @cntBadWid int;
 
select @cntBadWid=count(*)
	from vWineJ a
		left join vWAName b
			on a.wid=b.wid
	where a.wineN<0 and b.wid is null
if @cntBadWid>0
	begin
		print convert(nvarchar,@cntBadWid)+' wid wines with bad wid'
		return
	end;
 
with c as	(	select wid, count(distinct a.vinn)cntVinn 
					from vWAName a 
						join (select distinct vinn from vWineJ where wineN<0)b
							on a.vinn=b.vinn
					group by wid 
			)
select @cntBadWid=count(*) from c where cntVinn>1
if @cntBadWid>0
	begin
		print convert(nvarchar,@cntBadWid)+' wid with multiple vinn'
		return
	end
 
end
 
 







