create  function randomRating(@r int, @wineN int, @tastingN int) returns int as begin

           declare @r2 int, @bump float, @ran1 float, @ran2 float, @ran3 float

           

           select

                       @ran1 = (@wineN %  379) / (378.0)

                     , @ran2 = (@tastingN %  79) / (78.0)

                     , @ran3 = ((convert(bigint,@tastingN) * 1999) %  179) / (178.0)

           

           set @r2 = @r

           if @r2 < 50 set @r2 = 90

           set @bump = 

                     case 

                     when @ran1 < 0.2 then 1.0*@ran3

                     when @ran1 < 0.65 then 1.0+ 3.0*@ran3

                     when @ran1 < 0.90 then 4.0 + 3.0*@ran3

                     else 7.0 + 4.0*@ran3

                     end

 

           set @bump = round(@bump,0)

           if @ran2 < 0.5

                     set @r2 -= @bump

           else

                     set @r2 += @bump

 

           if @r2 < 50 set @r2 = @r

           if @r2 > 100 set @r2 = @r

           return @r2

           end

 

 
