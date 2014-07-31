-- test of small table insert xx [=]
CREATE function getWordsxx (@s nvarchar(3000))
returns @T table(w varchar(3000)) begin
insert into @T(w) select 'one'
insert into @T(w) select 'two'
insert into @T(w) select 'three'
insert into @T(w) select 'four'
insert into @T(w) select 'five'
insert into @T(w) select 'six'
insert into @T(w) select 'seven'
insert into @T(w) select 'eight'
insert into @T(w) select 'nine'
insert into @T(w) select 'ten'
return
end
