create proc savey as begin

begin try drop table yfforsale end try begin catch end catch
begin try drop table ynameYearRaw end try begin catch end catch
begin try drop table ynameYearNorm end try begin catch end catch
begin try drop table ynameYear end try begin catch end catch
begin try drop table yallocateWidVinn end try begin catch end catch
begin try drop table ywineName end try begin catch end catch
begin try drop table yidUse end try begin catch end catch
begin try drop table ywine end try begin catch end catch


select * into yfforsale from fforsale
select * into ynameYearRaw from nameYearRaw
select * into ynameYearNorm from nameYearNorm
select * into ynameYear from nameYear
select * into yallocateWidVinn from allocateWidVinn
select * into ywineName from wineName
select * into yidUse from idUse
select * into ywine from wine
end