--------------------------------------------------------------
/* TO DO
--------------------------------------------------------------
-- Adjust ooerp to allow for fullname
-- pub top side super-publications in for use in professional taster cross ref
		-- if we design these to be non-overlapping, then detecting other counts is easy
-- use calls to pubGtoWine to get counts for other topside publication groups


defer My Trusted Taster cross refs for further thinking


*/
--------------------------------------------------------------

-- aspx database crossref other reviews [=]
create function zz_getCrossReferences (@memberWhN int, @pubGN int, @wineN int)
returns @T table(pubGN int, title varchar(300), tasterN int)
as begin
	insert into @T(pubGN, title, tasterN) select 1, 'test cross ref', 2

	-- get list of all tastings not already included in the current pubGN
	-- get distinct pubN 
	-- for each pubN, backtrack using whN's trusted tasters
/*

declare @memberWhN int, @pubGN int, @wineN int
select @memberWhN = 3602, @pubGN = 18240, @wineN = 24575

-----------------------------------------------------------------
-- Need to think through expansion through PubGToPub vs expansion through whToTrusted
		-- There is overlap here
-----------------------------------------------------------------

select distinct pubN from tasting
	where pubN is not null and wineN = @wineN
		and not exists 
			(select * 
				from mapPubGToWineTasting 
					where pubGN = @pubGN
						and wineN = @wineN
				)

select * 
				from mapPubGToWineTasting 
					where pubGN = 18240
						and wineN = 24575

select distinct pubGN from mapPubGToWineTasting

select * from wh where whn = 18240


*/
return 
end




/*
----------------------------------------------------
with
a as (select wineN, source from rpowineDatad..wine group by wineN, source)
,b as (select wineN from a group by wineN having count(*) > 2)
select * from a where exists(select * from b where wineN = a.wineN) order by wineN, source
wineN	source
24575	Antonio Galloni
24575	Neal Martin
24575	Robert Parker




Find wines with WJ and RP and non RP reviews
From the WJ publication, do a query 
 
with
a as (select wineN, tasterN from tasting
select tasterN, count(*) from tasting group by tasterN
ooi ' tasting '
 
 
-- set up to work from whToTrusted so that all reviewers break out
-- set up a default to work when someone has no trusted taster explicit
 
 
 
ooi whtotru
 
insert into whToTrusted (whN, trustedN, isDerived) select 3602, 13, 0
rowversion
createDate
 
18223	Wine Advocate Group
18240	All Publications
1	Bordeaux Book, 3rd Edition
2	Burgundy Book
3	Buying Guide, 2nd Edition
4	eRobertParker.com
5	Italy Report
6	Neal Martin’s Wine Journal
8	Rhone Book
9	Wine Advocate
 
 3602 @MyWinesN = dbo.getWhn('MyIconTest')
 
 
select a.whN, b.fullName, trustedN, c.fullName, isDerived
	from whToTrusted a	join wh b on b.whN = a.whN join wh c on c.whN = a.trustedN
 
 
To pick best "upside" rep, we give priority to individual professional tasters at the top, then to the smallest containing groups


select distinct publication from rpowinedatad..wine
		Bordeaux Book, 3rd Edition
		Burgundy Book
		Buying Guide, 2nd Edition
		eRobertParker.com
		Italy Report
		Rhone Book
		Wine Advocate
		Wine Journal




----------------------------------------------------
*/
 

 
 
 
 
