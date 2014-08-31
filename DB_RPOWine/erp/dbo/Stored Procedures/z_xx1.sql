-- debug	test     xx          [=]
CREATE procedure z_xx1 (@MustHaveReviewInThisPubG bit = null, @MyWinesN int = null, @Where varchar(max) = null)as begin
if @MustHaveReviewInThisPubG = 1
	if @MyWinesN > 0
		if len(@Where) > 0  goto Review1_MyWines1_Where1
		else goto Review1_MyWines1_Where0
	else
		if len(@Where) > 0  goto Review1_MyWines0_Where1
		else goto Review1_MyWines0_Where0
else
	if @MyWinesN > 0
		if len(@Where) > 0  goto Review0_MyWines1_Where1
		else goto Review0_MyWines1_Where0
	else
		if len(@Where) > 0  goto Review0_MyWines0_Where1
		else goto Review0_MyWines0_Where0


Review1_MyWines1_Where1: 
	print 'Review1_MyWines1_Where1' 
	goto Done
Review1_MyWines1_Where0: 
	print 'Review1_MyWines1_Where0' 
	goto Done
Review1_MyWines0_Where1: 
	print 'Review1_MyWines0_Where1' 
	goto Done
Review1_MyWines0_Where0: 
	print 'Review1_MyWines0_Where0' 
	goto Done
Review0_MyWines1_Where1: 
	print 'Review0_MyWines1_Where1' 
	goto Done
Review0_MyWines1_Where0: 
	print 'Review0_MyWines1_Where0' 
	goto Done
Review0_MyWines0_Where1: 
	print 'Review0_MyWines0_Where1' 
	goto Done
Review0_MyWines0_Where0: 
	print 'Review0_MyWines0_Where0' 
	goto Done



Done:
end

/*
exec dbo.xx 0,0
exec dbo.xx 0,0, a
exec dbo.xx 0,1
exec dbo.xx 0,1, a
exec dbo.xx 1,0
exec dbo.xx 1,0, a
exec dbo.xx 1,1
exec dbo.xx 1,1, a

*/



