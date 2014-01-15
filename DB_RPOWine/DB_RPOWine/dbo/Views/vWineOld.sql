CREATE VIEW vWineOld

as

select distinct 
	Country = isnull(wn.Country, ''), 
	Region = isnull(wn.Region, ''), 
	Location = isnull(wn.Location, ''), 
	Locale = isnull(wn.Locale, ''), 
	Site = isnull(wn.Site, ''),
	Producer = isnull(wn.Producer, ''), 
	WineType = isnull(wn.WineType, ''), 
	LabelName = isnull(wn.LabelName, ''), 
	Variety = isnull(wn.Variety, ''), 
	Dryness = isnull(wn.Dryness, ''),
	ColorClass = isnull(wn.ColorClass, ''),
	Vintage = isnull(wn.Vintage, ''),
	EncodedKeywords = isnull(wn.encodedkeywords, ''),
	ID = Idn
from RPOWineData.dbo.Wine wn (nolock)

