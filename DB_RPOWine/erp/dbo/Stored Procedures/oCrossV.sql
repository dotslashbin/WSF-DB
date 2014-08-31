CREATE proc [dbo].[oCrossV] (@ta varchar(max), @tb varchar(max)=null, @taField varchar(max)=null)
as begin

--declare @ta varchar(max)='articleMasterN', @tb varchar(max),@taField varchar(max)
 
if @tb like '%[^ ]%'
	begin
		begin try drop table oCrossV_crossAll end try begin catch end catch
		select * into oCrossV_crossAll from dbo.oCrossT(@ta, @tb, '')
		exec dbo.ovv @ta,'','', 100,1, oCrossV_ta
		exec dbo.ovv @tb,'','', 100,1, oCrossV_tb
	end
else
	begin
		select @taField=@ta
	end
 
declare @crossRefs varchar(max)
select top 1 @crossRefs=crossRefs from oCrossV_crossAll where field = @taField;
 
if @crossRefs like '%[^ ]%'
	begin
		with
		a as (select * from dbo.oSplit(@crossRefs, ' '))
		,b as (select column_name part from information_schema.columns where table_name = 'ocrossv_tb')
		select @crossRefs = dbo.concatFF(a.part)
			from a
				join b
					on a.part =b.part
		set @crossRefs = replace(@crossRefs, char(12),',b.')
 
		declare @s nvarchar(max) = 'select a.@@@, b.' + @crossRefs +'
			from oCrossV_ta a
				join oCrossV_tb b
					on b.ii=a.ii'
		set @s = replace(@s, '@@@', @taField)
		begin try
			exec (@s)
		end try begin catch						
			select 'column not in value summary - probably Null'
		end catch
	end
else
	select 'Nothing'
end 
