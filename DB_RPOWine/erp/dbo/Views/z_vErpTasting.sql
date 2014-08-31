CREATE view [z_vErpTasting]  as 
select * 
	from tasting 
	where pubN in (select pubN from pubGToPub where pubGN = dbo.erpPub())
