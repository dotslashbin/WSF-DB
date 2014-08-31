create function doubleUpQuotes (@s varchar(max))
returns varchar(max)
as begin

--declare @s nvarchar(max)='-"one''two"-three'
--declare @s nvarchar(max)='-o"=>''<="-"  ''   "'
--declare @s nvarchar(max)='where contains ( encodedKeywords, '' ("Cos Estournel*" or "COS" or "C.O.S." or "Cos d''Estournel" or "Cos dEstournel" or "Cos Estournel") '')'
--declare @s nvarchar(max)='where contains ( encodedKeywords, '' ( "Cos d''Estournel" ) '')' 
--print dbo.doubleUpQuotes('where contains ( encodedKeywords, '' ("Cos Estournel*" or "COS" or "C.O.S." or "Cos d''Estournel" or "Cos dEstournel" or "Cos Estournel") '')')

declare @lastTransfered int=0, @leftDouble int=0, @rightDouble int=0, @r nvarchar(max)=''
set @leftDouble=charIndex('"',@s)
--print @leftDouble
while @leftDouble>0
	begin
		set @r+=substring(@s, @lastTransfered, @leftDouble-@lastTransfered)
		--print '1 |'+@r+'|'

		set @rightDouble=charindex('"',@s,@leftDouble+1)
		if @rightDouble=0
				break

		set @r+=replace(substring(@s, @leftDouble, @rightDouble-@leftDouble+1),'''','''''')
		set @lastTransfered=@rightDouble+1
		set @leftDouble=charindex('"',@s,@rightDouble+1)
		
		--print '2 |'+@r+'|'
	end
set @r+=substring(@s, @lastTransfered, len(@s)+1)

--print '3 |'+@r+'|'


return @r
end
