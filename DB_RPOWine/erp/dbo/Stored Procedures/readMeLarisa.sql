-- larisa shortcut [=]
CREATE proc readMeLarisa as begin set nocount on 
/*
Larisa, 
 
1. I've implemented the "2"  as the third option for the first argument of getCrossReferences (see example below)
2. I've implemented Group By for the two cases needed for the intermediate pages (see example below)
3. I haven't yet implemented the function that gives you the items to list in the publication drop down on the preferences screen
 

CROSS REFERENCE EXAMPLE
select * from getCrossReferences (0,18223, 107220)
		Neal Martin							6
 
select * from getCrossReferences (1,18223, 107220)
		Erp Bulletin Board					7023
		Erp Professionals					18240
		Executive Wine Seminar			7024
		Parker Zraly Certified				18244
		Trusted Tasters						18245
		Wine Clubs							18247
 
select * from getCrossReferences (2,7021, 107220)
		Atlanta Wine Club					2281
		Bejing Wine Club					6196
		Beveryly Hills Wine Club			3109
		Boca Wine Club					3111
		Brookline Wine Club				2282
		Central Park Wine Club			3110
		Knob Hill Wine Club				6193
		London Wine Club					6195
		Microsoft Wine Club				6194
		Newton Wine Club					2283
		Palm Beach Wine Club			2280
		Weston Wine Club					3108
 
 
GROUP BY EXAMPLE (Partial)

1. 	@select = 'Select producerShow, myIconN, pubIconN, forSaleIconN, count(*) numberOfWines'
	,@GroupBy = 'Group By FullWineName, ColorClass'

2.@select = 'Select fullWineName, colorClass, myIconN, pubIconN, forSaleIconN, count(*) numberOfVintages'
	,@GroupBy = 'Group By ProducerShow'




-------------------------------------------------------------
-- (Prior documentation, tables now somewhat out of date)
-------------------------------------------------------------
The cross reference function is now implemented
	getCrossReferences
It takes 3 arguments
	1. memberWhN		- the whN for the current user (NOT the member number from the logon subsystem)
		This will control the masterPubGN that determines the topside breakdown of cross references - see the examples below
		Rignt now, this isn't really used.  Instead, I've implemented it as a testing switch
			0 => use our existing "old" breakdown of just WA or WJ
			1 => use an alternate "test" breakdown that can return seveal cross references
	2. currentPubGN
		The current publication group.  In the old system this would have been either Wine Advocate or WJ.  In the new system it
		can represent multiple levels of nesting - for example we could breakout a group for books
	3. wineN
		The current wine number 
 
The wine number 22168 has a lot of reviews, so it's used in the examples below:
 
Execute "oopubg" to get an understandable overview of the current and test publication groupings  (see below for current listing)
 
select * from getCrossReferences(0, 6, 22168) 
	=>	crossName				crossPubGN
			-------------					---------------
			Wine Advocate			18223
 
 
select * from getCrossReferences(0, 9, 22168)
	=>	crossName				crossPubGN
			-------------					---------------
			Neal Martin				6
			Wine Advocate			18223
 
select * from getCrossReferences(0, 18223, 22168)
	=>	crossName				crossPubGN
			-------------					---------------
			Neal Martin				6
 
 
select * from getCrossReferences(1, 18223, 22168)
	=>	crossName				crossPubGN
			-------------					---------------
			Neal Martin				6
			Rhone Book				8
			x-Wine Advocate		18242
 
 
select * from getCrossReferences(1, 18242, 22168)
	=>	crossName				crossPubGN
			-------------					---------------
			Neal Martin				6
			Rhone Book				8
 
 
select * from getCrossReferences(1, 6, 22168)
	=>	crossName				crossPubGN
			-------------					---------------
			Rhone Book				8
			x-Wine Advocate		18242
 
 
 
 
oopubg
	=>	pubG												Pub													isDerived
			------												----													-----------
			All Publications (18240)					Wine Advocate Group (18223)			0
			All Publications (18240)					Wine Journal (6)								0
			All Publications (18240)					Bordeaux Book, 3rd Edition (1)			1
			All Publications (18240)					Burgundy Book (2)								1
			All Publications (18240)					Buying Guide, 2nd Edition (3)				1
			All Publications (18240)					eRobertParker.com (4)						1
			All Publications (18240)					Italy Report (5)									1
			All Publications (18240)					Rhone Book (8)									1
			All Publications (18240)					Wine Advocate (9)								1
			Bordeaux Book, 3rd Edition (1)		Bordeaux Book, 3rd Edition (1)			1
			Burgundy Book (2)							Burgundy Book (2)								1
			Buying Guide, 2nd Edition (3)			Buying Guide, 2nd Edition (3)				1
			eRobertParker.com (4)					eRobertParker.com (4)						1
			Italy Report (5)								Italy Report (5)									1
			Rhone Book (8)								Rhone Book (8)									1
			Wine Advocate (9)							Wine Advocate (9)								1
			Wine Advocate Group (18223)		Bordeaux Book, 3rd Edition (1)			0
			Wine Advocate Group (18223)		Burgundy Book (2)								0
			Wine Advocate Group (18223)		Buying Guide, 2nd Edition (3)				0
			Wine Advocate Group (18223)		eRobertParker.com (4)						0
			Wine Advocate Group (18223)		Italy Report (5)									0
			Wine Advocate Group (18223)		Rhone Book (8)									0
			Wine Advocate Group (18223)		Wine Advocate (9)								0
			Wine Journal (6)							Wine Journal (6)								1
			x-All Publications (18241)				Bordeaux Book, 3rd Edition (1)			0
			x-All Publications (18241)				Burgundy Book (2)								0
			x-All Publications (18241)				Buying Guide, 2nd Edition (3)				0
			x-All Publications (18241)				Italy Report (5)									0
			x-All Publications (18241)				Rhone Book (8)									0
			x-All Publications (18241)				Wine Journal (6)								0
			x-All Publications (18241)				x-Wine Advocate Group (18242)			0
			x-All Publications (18241)				eRobertParker.com (4)						1
			x-All Publications (18241)				Wine Advocate (9)								1
			x-Wine Advocate Group (18242)		eRobertParker.com (4)						0
			x-Wine Advocate Group (18242)		Wine Advocate (9)								0
*/
end
 
 
