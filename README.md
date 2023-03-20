# The Botanical Heatmaps


## Project Description

Under the Natural Capital and Ecosystem Assessment (NCEA), Natural England (NE) have been working in partnership with the Botanical Society of Britain and Ireland (BSBI) to further develop their botanical heatmaps derived from plant occurrence records from 1970 to present day, supplied from BSBI's central plant distribution database (BSBI, 2022). The BSBI initially developed these in partnership with NE and the Woodland Trust with the aim to utilise these data to support tree planting.

Under the NCEA Trees and Woodland Planting project, we developed these maps further for operational use to create easily interpretable spatial data layers. These data can be used to help inform decision-making and act as a toolkit for assessing the suitability of sites for tree and woodland establishment and other land management activities. These data can also support several other key policy areas, such as providing evidence for helping to verify priority sites and update national inventories such as the ancient woodland inventory, support environmental impact assessments, landscape recovery and targeting areas for restoration.


### Natural Capital & Ecosystem Assessment (NCEA)

The NCEA is a transformative programme to understand the extent, condition and change over time of environmental assets across England's land and water environments (freshwater and marine), supporting the government's ambition to improve the environment within a generation. On land it is a pioneering partnership between Defra, Natural England, Environment Agency, Forest Research, and the Join Nature Conservation Committee. NCEA aligns with the work of Natural England's Science, Evidence and Evaluation Strategy, Shift 4.


### Data Products

The botanical heatmaps summarise the latest vascular plant records collected by BSBI's expert volunteers to identify the number of Rare, Scarce and Threatened (RST) plant species and Priority Habitat Positive Indicator (PHPI) species within each monad (1 x 1 km grid cell). The PHPI heatmaps include attributes for the total number of PHPI species recorded, as well as the number of PHPI species recorded for each individual broad habitat type. The PHPI species are a combination of BSBI axiophytes, positive habitat indicators used for UK common standards monitoring, and ancient woodland indicators. Along with species counts, these data include the species list per grid cell and the date the species was last recorded. 

The summarised botanical value map is a categorised map identifying areas of high, moderate and low value for plant species. These are derived from the botanical heatmaps and assess the presence of priority species and positive habitat indicators that confirm the present of good quality semi-natural habitat. 

Data Inputs:
* BSBI summarised vascular plant records containing RST species at 100m and 1km resolutions, ancient woodland indicator subset at 1km resolution, and PHPI at 1km resolution. 
* BSBI recording days and total species counts per monad (1km)
* Ordnance Survey (2021) British National grids at 100m, 1km and 100km spatial scales. Available <a href="https://github.com/OrdnanceSurvey/OS-British-National-Grids">here</a>.
* Regional boundaries for England obtained from the Office for National Staatistics (2020). Available <a href="https://geoportal.statistics.gov.uk/datasets/ons::regions-december-2021-en-bfc-1/explore?location=52.754887%2C-2.489483%2C6.79">here</a>.
* country boundaries for the united kingdom obtained from the Office for National Staatistics (2020). Available  <a href="https://geoportal.statistics.gov.uk/search?collection=Dataset&sort=name&tags=all(BDY_CTRY%2CDEC_2021)">here</a>.  

Data Outputs:
* Ancient Woodland Indicator heatmap - summarised count of the number of ancient woodland indicators recorded per monad (1 x 1 km grid cells). Geopackage contains the count, species list, and when each species was last recorded within each monad
* Botanical heatmaps 1 km- Summarised counts of the number of conservation species (rare/scarce/threatened), Priority Habitat Positive  indicators and habitat indicators split out by broad habitat type, recorded per monad (1 x 1 km grid cells). Geopackage contains the count, species list and when the species were last recorded in each monad.
* Rare, Scarce and Threatened plant species heatmap 100 m - summarised count of the number of GB Rare, Scarce and Threatened plant species per hectare (100 x 100 m grid cells). Geopackage contains the count, species list and when the species w3ere last recorded in each monad
* Summarised Botanical value map - A map which demonstrates where the most important botanical areas are across England categorised into high, moderate and low. this is derived from the botanical heatmaps, and value is based on where priority species are present within a monad and the presence of positive habitat species indicating areas of high quality semi-natural habitat. 

### Processing Scripts


Workflow R markdown scripts and function scripts:

* HeatMapWorkflow_GeodatabaseLayers.Rmd - Workflow to create the the botanical heatmap geopackages from the summarised BSBI heatmap data.
* HeatMapWorkflow_BotanicalValueMap.Rmd - Workflow to create the botanical value map from the botanical indicators heatmap 1km.
* HeatMapWorkflow_functions.R - Functions called by the HeatMapWorkflow_BotanicalValueMap.Rmd script
* heatmapValidation.R - script for running through validation steps for the botanical heatmaps and value map against other datasets (PHI, SSSIs, AWI)

Analysis scripts:

* survey_effort_analysis.Rmd - Workflow for analysing survey coverage per monad using recording days as a proxy (where 40 or more species have been recorded).
* habitat_quality_analysis.Rmd - Workflow for analysing benchmarking botanical indicator heatmap data for assessing habitat quality.

### Software and package versions

The reproducible workflow was created in R version 4.2.2, with the following packages:
 tictoc_1.1         
 knitr_1.42         
 RColorBrewer_1.1-3 
 furrr_0.3.1        
 future_1.32.0      
 tmap_3.3-3        
 viridis_0.6.2      
 viridisLite_0.4.1  
 ggpubr_0.6.0       
 sf_1.0-9           
 forcats_0.5.2      
 stringr_1.5.0     
dplyr_1.0.10       
purrr_1.0.1        
readr_2.1.3        
tidyr_1.3.0        
tibble_3.1.8       
ggplot2_3.4.0     
tidyverse_1.3.2 

### Copyright

Copyright (c) 2022 Natural England & BSBI, reproduced with permission of <a href="https://www.gov.uk/government/organisations/natural-england">Natural England</a>. (c) Crown Copyright and database right [2022].

### Data accessibility and further information

Further information on the methodology for generating and analysing the data layers can be found in the <a href="http://publications.naturalengland.org.uk/publication/5063363230171136">technical report</a>. 

The botanical value map is published under an <a href="https://www.nationalarchives.gov.uk/doc/open-government-licence/version/3/">Open Government Licence v.3.0</a>m and available on Defra data platforms such as NE Open data portal available  <a href="https://naturalengland-defra.opendata.arcgis.com/maps/Defra::summarised-botanical-value-map-2021-england/about">here</a>.


The botanical heatmaps are more restrictive due to sensitivities in the speciesdata, for more information about accessing these data, please contact the team at botanicalheatmaps@naturalengland.org.uk.

### Acknowledgements
We would like to thank BSBI’s network of expert volunteers without whose tireless 
recording the analysis described in this report would not have been possible. We 
would also like to thank Natural England habitat specialists for their feedback on the 
development of the heatmaps, notably Mags Cousins, Iain Diack, Katey Stephen, 
Sean Cooch, Frances McCullagh, Alistair Crowle, Emma Goldberg, Marion Bryant, 
Louise Hutchby, Charlotte Moss and Alex Prendergast. We would also like to thank 
Christine Reid and Saul Herbert at the Woodland Trust for supporting the initial 
development of this work and to Jay Doyle of the Forestry Commission for useful 
discussions on how the heatmaps might be used to supporting the screening of tree 
planting proposals.


### Contact

Please get in touch if you have any queries regarding the botanical heatmaps or value map or would like to learn more. Please contact botanicalheatmaps@naturalengland.org.uk


