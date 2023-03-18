# The Botanical Heatmaps


## Project Background

Under the Natural Capital and Ecosystem Assessment (NCEA), Natural England (NE) have been working in partnership with the Botanical Society of Britain and Ireland (BSBI) to further develop their botanical heatmaps derived from plant occurrence records between 1970 and 2021, supplied from BSBI's central plant distribution database (BSBI, 2022). The BSBI initially developed these in partnership with NE and the Woodland Trust with the aim to utilise these data to support tree planting.

Under the NCEA Trees and Woodland Planting project, we developed these maps further for operational use to create easily interpretable spatial data layers. These data will inform decision-making and act as a toolkit for assessing the suitability of sites for tree planting and other land management activities. These data can also support several other key policy areas, such as providing evidence for helping to verify priority sites and update national inventories such as the ancient woodland inventory, support environmental impact assessments, landscape recovery and targeting areas for restoration.


### Natural Capital & Ecosystem Assessment (NCEA)

Currently in a pilot phase, NCEA is a transformative programme to understand the extent, condition and change over time of environmental assets across England's land and water environments (freshwater and marine), supporting the government's ambition to improve the environment within a generation. On land it is a pioneering partnership between Defra, Natural England, Environment Agency, Forest Research, and the Join Nature Conservation Committee. NCEA aligns with the work of NAtural England's Science, Evidence and Evaluation Strategy, Shift 4.


### Data Products

The botanical heatmaps summarise the latest plant records collected by BSBI's expert volunteers to identify the number of Rare, Scarce and Threatened (RST) plant species and Priority Habitat Positive Indicator (PHPI) species within each monad (1 x 1 km grid cell). The PHPI heatmaps include attributes for the total number of PHPI species recorded, as well as the number of PHPI species recorded for each individual broad habitat type. The PHPI species are a combination of BSBI axiophytes, positive habitat indicators used for UK common standards monitoring, and ancient woodland indicators. Along with species counts, these data include the species list per grid cell and the date the species was last recorded. The botanical heatmaps have been produced as three data products:

* Ancient Woodland Indicator heatmap - summarised count of the number of ancient woodland indicators recorded per monad (1 x 1 km grid cells). Geopackage contains the count, species list, and when each species was last recorded within each monad
* Botanical heatmaps 1 km- Summarised counts of the number of priority species (rare/scarce/threatened), positive habitat indicators and habitat indicators split out by broad habitat type, recorded per monad (1 x 1 km grid cells). Geopackage contains the count, species list and when the species were last recorded in each monad.
* Rare, Scarce and Threatened plant species heatmap 100 m - summarised count of the number of GB Rare, Scarce and Threatened plant species per hectare (100 x 100 m grid cells). Geopackage contains the count, species list and when the species w3ere last recorded in each monad

The summarised botanical value map is a categorised map identifying areas of high, moderate and low value for plant species. These are derived from the botanical heatmaps and assess the presence of priority species and positive habitat indicators that confirm the present of good quality semi-natural habitat. 
Data product:

* Summarised Botanical value map - A map which demonstrates where the most important botanical areas are across England categorised into high, moderate and low. this is derived from the botanical heatmaps, and value is based on where priority species are present within a monad and the presence of positive habitat species indicating areas of high quality semi-natural habitat. 

### Processing Scripts

Workflow R markdown scripts with knitted html versions:

* HeatMapWorkflow_GeodatabaseLayers.Rmd - Workflow to create the the botanical heatmap geopackages from the summarised BSBI heatmap data.
* HeatMapWorkflow_BotanicalValueMap.Rmd - Workflow to create the botanical value map from the botanical indicators heatmap 1km.
* HeatMapWorkflow_functions.R - Functions called by the HeatMapWorkflow_BotanicalValueMap.Rmd script
* heatmapValidation.R - script for running through validation steps for the botanical heatmaps and value map against other datasets (PHI, SSSIs, AWI)

Analysis scripts:

* survey_effort_analysis.Rmd - Workflow for analysing survey coverage per monad using recording days as a proxy (where 40 or more species have been recorded).
* habitat_quality_analysis.Rmd - Workflow for analysing benchmarking botanical indicator heatmap data for assessing habitat quality.

### Copyright

Copyright (c) 2022 Natural England & BSBI, reproduced with permission of <a href="https://www.gov.uk/government/organisations/natural-england">Natural England</a>. (c) Crown Copyright and database right [2022].

### Data accessibility and further information

Further information on the methodology for generating and analysing the data layers can be found in the technical report. Data are currently being licenced and will be available soon. The botanical value map will be released under an <a href="https://www.nationalarchives.gov.uk/doc/open-government-licence/version/3/">Open Government Licence v.3.0</a>. and available on data platforms: MAGIC, NE Open Data portal, Defra DSP, data.gov.
The botanical heatmaps are more restrictive due to sensitivities in the data, for access to these data please contact Natural England.

### Contact

Please get in touch if you have any queries regarding the botanical heatmaps or value map or would like to learn more. Please contact botanicalheatmaps@naturalengland.org.uk


