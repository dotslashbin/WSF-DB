
CREATE proc [dbo].[updateComplaint] (@whN int = null, @tastingN int = null)
as begin
set noCount on
declare @wineNupdated int = null;
update tasting 
	set hasUserComplaint = 1,
		userComplaintCount += case when hasUserComplaint = 0 then 1 else 0 end,
		@wineNUpdated = case when hasUserComplaint = 0 then wineN else null end
	where tastingN=@tastingN
	
if @wineNUpdated is not null 
	begin
		insert into complaints(whN,wineN,createDate,tastingN) select @whN, @wineNUpdated, getDate(),@tastingN
	end
set noCount off
end

