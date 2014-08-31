CREATE proc [dbo].[oFields] (@a varchar(max), @b varchar(max)=null     )
as begin
exec dbo.oFieldsInAButNotInB @a, @b
end
