## Botanical heatmaps workflow: data validation script 
#author: "Natural England"
#date: "17/03/2021"
#description: Script for validating how the botanical heatmaps and botanical value map compare with open source datasets describing sensitive sites for plant communities. 

library(rgdal)
library(sf)
library(dplyr)
library(tidyr)
setwd('D:/NE/Work/BSBI_HeatMaps/')

#----------------------------------------
# 1. SSSI sites

#priority species indicators
botanicalIndicators <- st_read('Products/BotanicalHeatMaps_Indicators_1970_2021.gpkg',layer='BotanicalIndicators_England_1km')
#load in SSSI boundaries
sssiBounds <- st_read('DataLayers/Sites_of_Special_Scientific_Interest_(England)/Sites_of_Special_Scientific_Interest__England____Natural_England.shp')
#extract monads for SSSIs
sssiMonads <- st_intersection(sssiBounds,botanicalIndicators) 
sssiMon <- sssiMonads %>% st_drop_geometry() %>% 
  select(monad,RDays_40,totPriority,allHabs) %>% 
  replace(.==-9999,NA)

summary(sssiMon)

#plot
sssiMonLong <- sssiMon %>% select(-RDays_40) %>% pivot_longer(!monad,names_to='indicators',values_to='value')
plotnames <- as_labeller(c('allHabs'='Positive Habitat Indicators','totPriority'='Priority Indicators'))
p1 <- ggplot(sssiMonLong,aes(x=value)) + geom_histogram() + theme_bw() + xlab('Number of indicator species') + ylab('Number of Monads')
p1 + facet_wrap(~indicators, scales='free', labeller=plotnames)
ggsave(paste0('Validation/SSSImonad_histograms.png'))

#total monads within SSSIs
total <- nrow(sssiMon)

##recording days
# number of monads with 3 recording days
goodcov <- sssiMon %>% filter(RDays_40>=3) %>% nrow()
goodcov/total*100
# number of monads with 0 recording days
nullRD <- sssiMon %>% filter(RDays_40==0) %>% nrow()
nullRD/total*100

## priority species
# number of monads with 0 priority species
nullpriority <- sssiMon %>% filter(totPriority==0) %>% nrow()
nullpriority/total*100
#percentage with more than 5 priority species
tenpriority <- sssiMon %>% filter(totPriority>=5) %>% nrow()
tenpriority/total*100

##habitat indicators
#percentage with more than 1 habitat indicators
onehabs <- sssiMon %>% filter(allHabs>=1) %>% nrow()
onehabs/total*100
#percentage with more than 25 habitat indicators
twentyfivehabs <- sssiMon %>% filter(allHabs>=25) %>% nrow()
twentyfivehabs/total*100
#percentage with more than 50 habitat indicators
fiftyhabs <- sssiMon %>% filter(allHabs>=50) %>% nrow()
fiftyhabs/total*100

# comparison with the value map - final output
val <- st_read('Products/botanicalValue_2021_England_1km.shp') %>% select(monad,valueCt)
sssiMonads <- st_intersection(sssiBounds,val) 
sssiMon <- sssiMonads %>% st_drop_geometry() %>% 
  select(monad,valueCt) %>% 
  replace(.==-9999,NA)
regionsumm <- sssiMon %>% group_by(valueCt) %>% summarise(count=n()) %>% 
  mutate(prop=count/(sum(regionsumm$count))*100)
write.csv(regionsumm,'Validation/botanicalValue_mw25km_England_1km_SSSIsumm.csv')

# comparison with the value map - regional benchmark
val <- st_read('IndicatorBaselines/botanicalValue_regions_England_1km.shp') %>% select(monad,valueCt)
sssiMonads <- st_intersection(sssiBounds,val) 
sssiMon <- sssiMonads %>% st_drop_geometry() %>% 
  select(monad,valueCt) %>% 
  replace(.==-9999,NA)
regionsumm <- sssiMon %>% group_by(valueCt) %>% summarise(count=n())
write.csv(regionsumm,'Validation/botanicalValue_region_England_1km_SSSIsumm.csv')

# comparison with the value map - tetrad benchmark
val <- st_read('IndicatorBaselines/botanicalValue_tetrad_England_1km.shp') %>% select(monad,valueCt)
sssiMonads <- st_intersection(sssiBounds,val) 
sssiMon <- sssiMonads %>% st_drop_geometry() %>% 
  select(monad,valueCt) %>% 
  replace(.==-9999,NA)
tetradSumm <- sssiMon %>% group_by(valueCt) %>% summarise(count=n())
write.csv(tetradSumm,'Validation/botanicalValue_tetrad_England_1km_SSSIsumm.csv')

#--------------------------------------------------------------

#2. Ancient woodland inventory

#ancient woodland indicators
AWIndicators <- st_read('D:/NE/Work/BSBI_HeatMaps/Products/AWI_England_1km.gpkg',layer='AWI_poly')
AWI <- st_read('DataLayers/Ancient_Woodland_(England)/Ancient_Woodland___Natural_England.shp')
awiMonads <- st_intersection(AWI,AWIndicators) 
awiMon <- awiMonads %>% st_drop_geometry() %>% 
  select(monad,RDays_40,totAWI) %>% 
  replace(.==-9999,NA)
summary(awiMon)

#plot AWI indicators
ggplot(awiMon,aes(x=totAWI)) + geom_histogram(fill="#74c476",color="black") + theme_bw() + xlab('Number of indicator species') + ylab('Number of Monads')
ggsave(paste0('Validation/AWIIndicators_comparisonAWI_histogram.png'))

#stats##
#total monads within SSSIs
total <- nrow(awiMon)
# number of monads with 3 recording days
goodcov <- awiMon %>% filter(RDays_40>=3) %>% nrow()
goodcov/total*100

# number of monads with 0 recording days
nullRD <- awiMon %>% filter(RDays_40==0) %>% nrow()
nullRD/total*100

# number of monads with over 5
tenawi <- awiMon %>% filter(totAWI>=10) %>% nrow()
tenawi/total*100

#how many monads not in inventory with AWIs?
presentAWI <- AWIndicators %>% st_drop_geometry() %>% filter(totAWI>=10) %>% 
  filter(!monad %in% awiMon$monad)
nrow(presentAWI)

#total english monads
presentAWI <- AWIndicators %>% st_drop_geometry() %>% filter(totAWI>=1)
total <- nrow(AWIndicators)
(nrow(presentAWI)/total)*100
(nrow(awiMon)/total)*100

#--------------------------------------------------------------

#3. Priority habitats inventory
central <- st_read('DataLayers/Priority_Habitat_Inventory__Central___England_-shp/Priority_Habitats_Inventory__Central___England____Natural_England.shp')
north <- st_read('DataLayers/Priority_Habitat_Inventory__North___England_-shp/Priority_Habitats_Inventory__North___England____Natural_England.shp')
south <- st_read('DataLayers/Priority_Habitat_Inventory__South___England_-shp/Priority_Habitats_Inventory__South___England____Natural_England.shp')
botanicalIndicators <- st_read('D:/NE/Work/BSBI_HeatMaps/Products/BotanicalHeatMaps_Indicators_1970_2021.gpkg',layer='BotanicalIndicators_England_1km')

#phi intersecting
centralMonads <- st_intersection(central,botanicalIndicators) 
northMonads <- st_intersection(north,botanicalIndicators) 
southMonads <- st_intersection(south,botanicalIndicators) 

#overall presence of habitat indicators
centralallHabs <- centralMonads %>% st_drop_geometry() %>% 
  select(monad,allHabs,region) %>% 
  replace(.==-9999,NA)
northallHabs <- northMonads %>% st_drop_geometry() %>% 
  select(monad,allHabs,region) %>% 
  replace(.==-9999,NA)
southallHabs <- southMonads %>% st_drop_geometry() %>% 
  select(monad,allHabs,region) %>% 
  replace(.==-9999,NA)
all <-rbind(centralallHabs,northallHabs,southallHabs)
summary(all)

#plot  indicators
ggplot(all,aes(x=allHabs)) + geom_histogram() + theme_bw() + xlab('Number of indicator species') + ylab('Number of Monads')
ggsave(paste0('Validation/allHabitatIndicators_comparisonPHI_histogram.png'))

#plot  indicators by region
ggplot(all,aes(x=allHabs)) + geom_histogram() + theme_bw() + xlab('Number of indicator species') + ylab('Number of Monads') + facet_wrap(~region, scales = "free_y")
ggsave(paste0('Validation/allHabitatIndicators_comparisonPHI_histByRegion.png'))


## broad habitats
unique(centralMonads$Main_Habit)

central <- centralMonads %>% st_drop_geometry() %>% 
  replace(.==-9999,NA)
north <- northMonads %>% st_drop_geometry() %>% 
  replace(.==-9999,NA)
south <- southMonads %>% st_drop_geometry() %>% 
  replace(.==-9999,NA)
all <-rbind(central,north,south)
all<- all %>% select(monad,Main_Habit,arable:woodland) %>% unique()

##woodland
woodland <- all %>% filter(Main_Habit %in% c('Traditional Orchards', "Deciduous woodland")) %>% 
  select(-Main_Habit) %>% unique() %>% select(woodland)
summary(woodland)
wood <- ggplot(woodland,aes(x=woodland)) + geom_histogram() + theme_bw() + xlab('Number of indicator species') + ylab('Number of Monads')
ggsave(paste0('Validation/WoodlandIndicators_comparisonPHI_hist.png'))
# number of monads with 0 woodland indicators
nowood <- woodland %>% filter(woodland==0) %>% nrow()
nowood/nrow(woodland)*100
# number of monads with 10 woodland indicators
tenwood <- woodland %>% filter(woodland>=10) %>% nrow()
tenwood/nrow(woodland)*100
# number of monads with 30 woodland indicators
thirtywood <- woodland %>% filter(woodland>=30) %>% nrow()
thirtyywood/nrow(woodland)*100

##grassland
grassland <- all %>% filter(Main_Habit %in% c('Good quality semi-improved grassland', 
                                             'Lowland meadows',
                                             "Lowland dry acid grassland",
                                             "Lowland calcareous grassland",
                                             "Coastal and floodplain grazing marsh",
                                             "Upland hay meadow", "Upland calcareous grassland"  )) %>% 
  select(-Main_Habit) %>% unique() %>%select(grassland)
summary(grassland)
ggplot(grassland,aes(x=grassland)) + geom_histogram() + theme_bw() + xlab('Number of indicator species') + ylab('Number of Monads')
ggsave(paste0('Validation/GrasslandIndicators_comparisonPHI_hist.png'))
# all monads have more than 1 indicator present
grassland %>% filter(grassland==0) %>% nrow()

# number of monads with 10 woodland indicators
tengrass <- grassland %>% filter(grassland>=10) %>% nrow()
tengrass/nrow(grassland)*100
# number of monads with 30 woodland indicators
thirtygrass <- grassland %>% filter(grassland>=30) %>% nrow()
thirtygrass/nrow(grassland)*100

##Fen Marsh Swamp
fenMarshSwamp <- all %>% filter(Main_Habit %in% c('Lowland fens', 
                                              'Reedbeds',
                                              "Purple moor grass and rush pastures",
                                              "Upland flushes, fens and swamps" )) %>% select(-Main_Habit) %>% unique() %>% select(fenMarshSwamp)
summary(fenMarshSwamp)
ggplot(fenMarshSwamp,aes(x=fenMarshSwamp)) + geom_histogram() + theme_bw() + xlab('Number of indicator species') + ylab('Number of Monads')
ggsave(paste0('Validation/FenMarshSwampIndicators_comparisonPHI_hist.png'))

# number of monads with 0 woodland indicators
fenMarshSwamp %>% filter(fenMarshSwamp==0) %>% nrow()
# number of monads with 10 woodland indicators
tenfen <- fenMarshSwamp %>% filter(fenMarshSwamp>=10) %>% nrow()
tenfen/nrow(fenMarshSwamp)*100
# number of monads with 30 woodland indicators
thirtyfen <- fenMarshSwamp %>% filter(fenMarshSwamp>=30) %>% nrow()
thirtyfen/nrow(grassland)*100


##heath and bog
heathBog <- all %>% filter(Main_Habit %in% c("Upland heathland","Lowland heathland",
                                             "Fragmented heath" ,"Blanket bog","Lowland raised bog" )) %>% select(-Main_Habit) %>% unique() %>% select(heathBog)
summary(heathBog)
ggplot(heathBog,aes(x=heathBog)) + geom_histogram() + theme_bw() + xlab('Number of indicator species') + ylab('Number of Monads')
ggsave(paste0('Validation/heathBogIndicators_comparisonPHI_hist.png'))
# number of monads with 0 heathBog indicators
nobog <- heathBog %>% filter(heathBog==0) %>% nrow()
nobog/nrow(heathBog)*100
# number of monads with 10 heathBog indicators
tenbog <- heathBog %>% filter(heathBog>=10) %>% nrow()
tenbog/nrow(heathBog)*100
# number of monads with 30 heathBog indicators
thirtybog <- heathBog %>% filter(heathBog>=30) %>% nrow()
thirtybog/nrow(heathBog)*100


##coastal
coastal <- all %>% filter(Main_Habit %in% c("Coastal saltmarsh","Mudflats","Maritime cliff and slope","Coastal sand dunes","Coastal vegetated shingle","Saline lagoons" ))  %>%  select(-Main_Habit) %>% unique() %>% select(coastal)
summary(coastal)
ggplot(coastal,aes(x=coastal)) + geom_histogram() + theme_bw() + xlab('Number of indicator species') + ylab('Number of Monads')
ggsave(paste0('Validation/coastalIndicators_comparisonPHI_hist.png'))
# number of monads with 0 coastal indicators
nocoast <- coastal %>% filter(coastal==0) %>% nrow()
nocoast/nrow(coastal)*100
# number of monads with 10 coastal indicators
tencoast <- coastal %>% filter(coastal>=10) %>% nrow()
tenbog/nrow(coastal)*100
# number of monads with 30 coastal indicators
thirtycoast <- coastal %>% filter(coastal>=30) %>% nrow()
thirtycoast/nrow(coastal)*100

##inland rock
inlandrock <- all %>% filter(Main_Habit %in% c( "Calaminarian grassland")) %>%  select(-Main_Habit) %>% unique() %>% select(inlandRock)
summary(inlandrock)
ggplot(inlandrock,aes(x=inlandRock)) + geom_histogram() + theme_bw() + xlab('Number of indicator species') + ylab('Number of Monads')
ggsave(paste0('Validation/inlandRockIndicators_comparisonPHI_hist.png'))
# number of monads with 0 heathBog indicators
norock <- inlandrock %>% filter(inlandrock==0) %>% nrow()
# number of monads with 10 heathBog indicators
tenrock <- inlandrock %>% filter(inlandrock>=10) %>% nrow()
tenrock/nrow(inlandrock)*100
# number of monads with 30 heathBog indicators
thirtyrock <- inlandrock %>% filter(inlandrock>=30) %>% nrow()
thirtyrock/nrow(inlandrock)*100
