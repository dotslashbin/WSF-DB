
CREATE proc [dbo].[updateWhToWineRecord_before25Jan2010](@whN int, @wineN int, @fieldname varchar(50), @param int, @comm varchar(250))

as begin

set noCount on;
            begin
                       if not exists (select * from whToWine where whN = @whN and wineN = @wineN)
                          
                             insert into whToWine (whN, wineN)  values ( @whN, @wineN )
                             
                          end
                          
       if  @fieldName='WantToTry'
         update whToWine set WantToTry=@param where wineN=@wineN and whn=@whn
            
      if  @fieldName='IsOfInterest'
         update whToWine set IsOfInterest=@param where wineN=@wineN and whn=@whn
         
      -- if @fieldname ='userComments'
       --  update whToWine set userComments=@comm where wineN=@wineN and whn=@whn    
         
       if    @fieldname ='wantToSellBottleCount' 
         update whToWine set wantToSellBottleCount=@param where wineN=@wineN and whn=@whn 
               
       if    @fieldname ='wantToBuyBottleCount' 
         update whToWine set wantToBuyBottleCount=@param where wineN=@wineN and whn=@whn 

       if    @fieldname ='bottleCount' 
         update whToWine set bottleCount=@param where wineN=@wineN and whn=@whn 

       if    @fieldname ='tastingCount' 
         update whToWine set tastingCount=@param where wineN=@wineN and whn=@whn 

       if    @fieldname ='buyerCount' 
         update whToWine set buyerCount=@param where wineN=@wineN and whn=@whn 
      
          
          
    exec calcWhToWine @whn,@wineN                     
                      
end

 


