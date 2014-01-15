CREATE PROCEDURE srv.WineLabel_ResetDefaults

--
-- Computes and resets default ColorID and DrynessID in WineLabel Table.
-- Used to correctly form Name (computed).
--

AS
set nocount on

begin tran 
	update WineLabel set DefaultColorID = -1, DefaultDrynessID = -1
	
	; with 
	tot as (
		select Label, LabelID, cnt = count(*)
		from vWineDetails
		where Label != ''
		group by Label, LabelID
	)
	, 
	stat as (
		select Label, LabelID, Dryness, DrynessID, Color, ColorID, cnt = count(*)
		from vWineDetails
		where Label != ''
		group by Label, LabelID, Dryness, DrynessID, Color, ColorID
	)
	--select stat.*, Total = tot.cnt, Prob = cast(stat.cnt as money) / tot.cnt
	update WineLabel set 
		DefaultColorID = stat.ColorID,
		DefaultDrynessID = stat.DrynessID
	from WineLabel 
		join tot on tot.LabelID = WineLabel.ID
		join stat on tot.LabelID = stat.LabelID
	where tot.cnt > 100 and (cast(stat.cnt as money) / tot.cnt) > 0.8	-- probability > 80%
commit tran

RETURN 1