--coding doug todo          [=]
CREATE procedure todoDoug as begin set nocount on /*


 
Package up the popup
 
Database call to access tasting notes
Database call to access / enter bottle counts and locations
 
RecentFunctions
	showmypopup
	myPopup 
 
 
Give tools for entering tasting notes.
 
 
 
-- MY WINES 
		-- FLAG
		-- JOIN
		-- Identify a good test user where all wines are present
 
 
-- TEST DIFFERENT SORTS
 
-- PUBICONN
 
 
-- GROUPING COUNT FIELDS
		-- VINTAGECOUNT
		-- WINECOUNT
 
 
 
 
FROM LARISA
			Here are the fields I need for the Selected Wines (Text Search) datagrid:
			WineN
			ColorClass
			Vintage
			ScreenWineName = isnull(ProducerShow,'') + ' ' +  isnull(LabelName,'')
			MostRecentPrice (I am not sure how we are going to handle the AuctionPrice here)
			Rating 
			Publication (are we going to use the Publication to show the icon?)
			Notes
 
			Arguments for the function:
			Keyword
			Sort Expression
			Sort Dirrection
 
 
-- MULTIPLE TASTING.		set the multiple tasting bit in mapPubGToWine
 
-- CREATEDATE Triggers
		need to set createdate on a number of the tables  (wineAlt, vinnAlt)
 
-- UPDATE.	move existing update mechanism into procs
 
-- MISSING WINEN
		-- Update WineAlt and VinnAlt to include the missing ones from the bottle table and the whToWIne table
 
-- finish defining the word breakout and it's use in oometa listing of one row per meta word
-- doublecheck categories to prove that all are in the oocategory listing
-- develop a convention to put a one line description and list it in some utility fun
 
-- ARTICLES => TASTING		finish developing the database scanner for setting articles
	-- articleToTasting
 
 
 
-- revise data entry procedures to create wineName for all erpSearch wines
 
-- Wine, WineName, and Tasting views for Larisa use visual view definition to hack together
 
-- Summary mechanism showing value distribution per column
 
-- Automatic generation of queries that only show the "interesting" columns
 
RECENT
myPopup
wineSQL
getMyWineOverview
forceUpdateMyWineOverview
xx1
memTemp
xx
mem
wineSQL5
wineSQLXX
wineSQL4
getCrossReferences
xxBetterPub
getPubDropDown
getPubDropDown2
readMeLarisa
updateMapPubGToWine
z_updateMapPubGToWine
ooerp
ootaster
updateWhToTaster
oopubg2
updatePubGRecurse
oopubg
z_updateMapWineToPubGPub
xxTimeTestWineSQL
xxPubOrder
formatPrice
ooFun
xxTimeTestTableCLR
GetStrings
GetWords
Concat
combineLocations
combinePlaces
computeMaturity
convertSurname
dropParenNote
utilRegexMatch
DeduceSourceDate
memBuildClrAssemply
getWordsxx
Timer
oomi
ooim
ooKey
z_ooKey
oomf
oofm
getCrossReferencesD
getCrossReferences3
getCrossReferences2
getName
zz_getCrossReferences
updateTrustedRecurse
oom
formatPriceRelease
updateArticleFromRpoWineData
getJoinA
xxArticle
updateWineNameProducerURL
updateErp
wineSQL3
updateMapPubGToWineTasting
oodef
oodeff
z_updatePubG
ooLarisa
toggleMyWine
ooicons
wineSQL2
findGoodTestMyWineSetDisplayName
SummarizefWhToWine
updateWhToWine
todoDoug
wineSQL_old1
xxx
wineSQLFields
fWine
z_xx1
snapRowVersion
erpDefaultUpdateId
ooitv
z_updateMaps
fWineNotes
getKeywordLine
oosum2
ooSum
updatePriceAll
updatePricePart
z_UpdatePrice
updateErpWineFromAlt
isEq
updateErpWineNamesFromErpSearch
updateErpWineAndVinnAltFromErp
oon
getWhN
ood
ooToDo
z_todoDevelopViewsForLarisa
oodiv
oovid
z_cols2
ooMetaFun
updateErpRetailersFromErpSearch
updateErpFromRpoWineData
updateErpFromErpSearch
wordsToTableFun
z_priceUpdate
z_allCol
updateWineNameErpSearchToErp
updateDougErpSearchFromWeb
ooCategories
addToViewDef
sp_helpindexdwf
z_mergeCols
z_allColFun
erpPub
oov
ooe
ooeg
ooge
oodfr
oofdr
oometa
oodit
oodti
oodf
oofd
ooda
ooad
oovtd
oovd
ootvd
ootd
ooid
oodv
oodtv
oodt
oodi
oot
oort
oorv
oovr
oofr
ooti
oooi
ooo
oorf
ooa
ooai
oovi
ooiv
ooi
oof
oor
oo
ooOld
oomem
findPub
normalizeForLike
getPubN
tabs
colsT
pageOrder
getPrices
getEditorN
getTasterN
getJoinX
getContainsArg
Concatenate
EventNotificationErrorsQueue
ServiceBrokerQueue
QueryNotificationErrorsQueue
 
 
 
 
 
*/ end
 
 
 
 
 
