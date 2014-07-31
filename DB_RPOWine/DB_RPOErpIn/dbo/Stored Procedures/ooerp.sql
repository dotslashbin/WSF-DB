-- coding constants erp utility [=]
CREATE procedure [dbo].[ooerp] as begin
select whN, tag, fullname, shortname, displayName, comments, iconN
	,isPub, isTasterAsPub, isGroup, isProfessionalTaster, isRetailer
	from wh 
	where 
		((tag is not null  or shortname is not null) and (isRetailer = 0 or isGroup = 1))
		or isProfessionalTaster = 1 or isErpMember = 1 or isTasterAsPub = 1
	order by case when comments like '%fake%' then 1 else 0 end
		,(case when isPub = 1 or isTasterAsPub = 1 then 1 else 0 end) desc, isPub desc, isGroup desc, isProfessionalTaster desc, isRetailer desc
		,isnull(tag,'zz'),isnull(fullname, 'zz'), isnull(shortname, 'zz'), isnull(displayname,'zz'), isnull(comments,'zz')
end
 
