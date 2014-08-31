--util memory temp [=]
create proc memTemp as begin set noCount on /*

select top 100 a.wineN, producerShow, labelName, vintage, maxRating
	from
		(select wineN, wineNameN, max(rating) maxRating from tasting group by wineN, wineNameN
			) a
	join winename b
		on a.wineNameN = b.wineNameN
	join wine c
		on c.wineN = a.wineN
	where exists
		(select 1
			from mapPubGToWine d
			where d.pubGN = 18247 and d.wineN = a.wineN
			)
	order by maxRating desc

wineN	producerShow	labelName	vintage	maxRating
55620	Quinta do Noval	Nacional	1997	100
82644	Sloan	Proprietary Red	2002	100
88695	Torbreck	Run Rig	2001	99
21963	Domaine Armand Rousseau	Chambertin	1985	99
67692	Rieussec	NULL	2001	99
101394	Standish	Shiraz / Viognier The Relic	2004	99
92520	Sine Qua Non	Heart Chorea (Syrah)	2002	99
62814	Domaine Weinbach	Tokay Pinot Gris Altenbourg Selection de Grains Noble	1998	99
41550	Jo Pithon	Coteaux du Layon St Aubin Clos des Bois	1995	98
97924	Pavie-Macquin	NULL	2005	98
95043	Torbreck	Les Amis	2003	98
84619	Pavie	NULL	2003	98
94776	Penfolds	Bin 60A	2004	98
97922	Pavie	NULL	2005	98
92475	Saxum	Rocket Block James Berry Vineyard	2003	98
89739	Pierre Usseglio	Chateauneuf du Pape Cuvee de Mon Aieul	2003	97
67613	Pavie	NULL	2001	97
37683	Petrus	NULL	1995	97
72270	Domaine Weinbach	Gewurztraminer Altenbourg Quintessence de Grains Nobles	2000	97
88545	Rusden	Shiraz Black Guts	2001	97
37734	Pichon-Longueville Comtesse de Lalande	NULL	1995	96
113569	Penfolds	Cabernet Sauvignon Cellar Reserve	2005	96
37839	Quintarelli	Alzero Vino da Tavola Cabernet Franc	1990	96
100164	Sine Qua Non	Li''L E (Grenache)	2003	96
33161	Penfolds	Grange	1981	96
87459	Sine Qua Non	SQN (Grenache / Syrah)	2002	96
33160	Penfolds	Grange	1980	96
29658	Chateau Soucherie (P Y Tijou)	Domaine de la Soucherie Coteaux du Layon Vieilles Vignes	1990	96
95979	Sloan	Proprietary Red	2004	96
101478	Two Hands	Shiraz Roennfeldt Road Zippy''s Block	2004	96
105435	Domaine Roger Sabon	Chateauneuf du Pape le Secret de Sabon	2005	96
31161	Trotanoy	NULL	1971	96
27126	Joseph Phelps	Cabernet Sauvignon Eisele Vineyard	1978	96
107220	Pavie	NULL	2006	96
30657	Selbach-Oster	Zeltinger Schlossberg Riesling Eiswein	1992	96
109188	Domaine Gerard Raphet	Chambertin Clos de Beze	2005	96
24781	Domaine du Pegau	Chateauneuf du Pape Cuvee Reservee	1990	96
100167	Sine Qua Non	Proprietary White Wine (Not Yet Named)	2005	96
107436	Selbach-Oster	Riesling Auslese Zeltinger Schlossberg (2 Star)	2005	96
82452	Pax Cellars	Syrah Alder Springs The Terraces	2002	96
23247	Charles Schleret	Gewurztraminer Vendange Tardive Herrenweg	1990	96
119499	Tibor Gal	Tokaji Aszu 6 Puttonyos	2000	96
29280	Paolo Scavino	Barolo Cannubi	1990	95
90633	Vineyard 29	Cabernet Sauvignon	2003	95
115928	Pax Cellars	Syrah Kobler Family Vineyard	2005	95
109104	Podere Il Carnasiciale	IGT Il Caberlot	2004	95
91325	Pavie	NULL	2004	95
60985	Parker Coonawarra Estate	Terra Rossa First Growth	1998	95
115956	E Pira-Chiara Boschis	Barolo Cannubi	2004	95
52164	Domaine de la Romanee Conti	Romanee Conti	1997	95
38565	Turley Wine Cellars	Zinfandel Aida Vineyard	1995	95
82450	Pax Cellars	Syrah Cuvee Keltie	2002	95
88422	Paracombe	Shiraz Somerville	2001	95
41562	Plumpjack	Cabernet Sauvignon Reserve	1995	95
113584	Penfolds	Shiraz Rwt	2004	95
109992	Tardieu-Laurent	Hermitage Vieilles Vignes	2003	95
98232	Zerbina	Albana di Romagna Passito Scacco Matto	2001	95
76614	Domaine de Panisse	Chateauneuf du Pape Noble Revelation	2000	95
60971	Pape Clement	NULL	2000	95
88728	Two Hands	Shiraz Deer In The Headlights	2002	95
107526	Vietti	Barolo Rocche	1985	95
65804	Domaine du Pegau	Chateauneuf du Pape Cuvee Reservee	2000	95
78729	Domaine de la Romanee Conti	La Tache	2001	95
66669	Rockford	Shiraz Basket Press	1991	95
41886	Domaine Georges Roumier	Musigny	1995	95
93774	Domaine de la Romanee Conti	Echezeaux	2003	95
68565	Prager	Riesling Smaragd Achleiten	2000	95
66601	Penfolds	Grange	1997	94
109164	Jacques Prieur	Musigny	2005	94
38439	Tarlant	Cuvee Louis Brut	NV	94
35085	Robert Talbott	Chardonnay Diamond T Estate	1992	94
62412	Torbreck	Juveniles	1999	94
108210	Domaine de la Romanee Conti	Richebourg	1989	94
87534	Taylor	Fladgate Vintage Port	1983	94
51711	Tardieu-Laurent	Cote Rotie Cote Brune	1996	94
114048	Spinifex	Shiraz / Viognier	2005	94
54516	Vietti	Barolo Rocche	1996	94
82456	Pax Cellars	Syrah Castelli Knight Ranch	2002	94
95856	Ramey	Jericho Canyon Vineyard Proprietary Red Wine	2004	94
52170	Emmanuel Rouget	Vosne Romanee Cros Parantoux	1997	94
90363	Patz and Hall	Chardonnay Alder Springs Vineyard	2003	94
93858	Siduri	Pinot Noir Pisoni Vineyard	2004	94
86352	Jacques Prieur	Chambertin	2002	94
83835	Willi Schaefer	Riesling Spatlese Graacher Domprobst A P #1203	2002	94
116166	Snowden	Cabernet Sauvignon Reserve	2006	94
97926	Pedestal	Merlot	2003	94
107517	Vidal Fleury	Cote Rotie la Chatillonne Cote Blonde	2003	94
71046	Talbot	NULL	1945	94
85392	Piaggia	Carmignano Riserva	2000	94
41443	Penfolds	Cabernet Sauvignon Bin 707	1993	94
101295	Willi Schaefer	Graacher Himmelreich Riesling Auslese A P #9	2005	94
35313	Domaine Weinbach	Riesling Cuvee Ste Catherine Schlossberg	1993	94
111414	Quilceda Creek	Merlot	2004	94
111365	Pepper Bridge Winery	Pepper Bridge Vineyard Reserve	2003	94
37866	Rauzan-Segla (Rausan-Segla)	NULL	1995	94
61020	Pavie-Decesse	NULL	1999	94
63622	Panther Creek Cellars	Pinot Noir Reserve	1999	93
116109	Scarecrow	Cabernet Sauvignon	2006	93
82457	Pax Cellars	Syrah Walker Vine Hill	2002	93
108051	Seguin-Manuel	Batard Montrachet Grand Cru	1915	93

*/
end

