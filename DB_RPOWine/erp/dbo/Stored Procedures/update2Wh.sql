CREATE proc update2Wh
as begin
exec dbo.ooLog 'update2Wh begin' ;

with
a		as			(select distinct publication from erpin..ewine a where not exists (select * from wh where fullName = a.publication))
insert into wh(fullName, displayName, sortName, createDate, isPub, isFake)
	select publication fullName, publication displayName, publication sortName, GETDATE() createDate, 1 isPub, 0 isFake from a where Publication is not null;
 
with
a		as			(select distinct source from erpin..ewine a where not exists (select * from wh where fullName = a.source))
insert into wh(fullName, displayName, sortName, createDate, isProfessionalTaster, isFake)
	select source fullName, source displayName, source sortName, GETDATE() createDate, 1 isProfessionalTaster, 0 isFake from a where Source is not null

exec dbo.ooLog 'update2Wh end' ;
 end

