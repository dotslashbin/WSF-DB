CREATE proc [dbo].[example]
as begin
set nocount on

/*
Keywords:		[___________________]

Country:				[_____________]
Producer:				[_____________]
Region:				[_____________]
Location:				[_____________]
Sublocation:			[_____________] 
Detailed Location:	[_____________]
Variety:				[_____________]
Color:					[_____________]
Proprietary Namr:	[_____________]
*/

select * from locationChoices ('co', null, null, null, null, null)
select * from locationChoices ('co m', null, null, null, null, null)
select * from locationChoices ('co mo', null, null, null, null, null)
select * from locationChoices ('co mou', null, null, null, null, null)

select * from regionChoices ('co', null, null, null, null, null)
select * from regionChoices ('co m', null, null, null, null, null)
select * from regionChoices ('co mo', null, null, null, null, null)
select * from regionChoices ('co mou', null, null, null, null, null)

select * from locationChoices ('usa              co                   mount', null, null, null, null, null)
select * from locationChoices ('              co                   mount', null, null, null, null, null)
select * from locationChoices ('              co                   mou', null, null, null, null, null)
select * from locationChoices ('                                 mount', 'australia', null, null, null, null)
select * from locationChoices ('                                 ', null, 'washington', null, null, null)
select * from locationChoices ('  ', null, 'washington', null, null, null)
select * from locationChoices (null, null, 'washington', null, null, null)
select * from locationChoices ('s  ', null, 'washington', null, null, null)
 
 
set statistics time  on
select * from locationChoices ('s  ', null, 'washington', null, null, null)
select * from locationChoices ('g  ', null, 'washington', null, null, null)
select * from locationChoices ('t  ', null, 'washington', null, null, null)
select * from locationChoices ('v  ', null, 'washington', null, null, null)
set statistics time off

end
