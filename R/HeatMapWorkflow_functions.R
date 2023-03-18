
#title: "Botanical Heatmap Workflow - Functions script"
#author: "Natural England"
#date: "16/03/2021"
#output: html_document

  
# Functions for use in the creation of the botanical value map 'HeatMapWorkflow_BotanicalValueMap.Rmd' and 'habitat_quality_analysis.Rmd'.

#These include:
# classifyHabs() - for classifying a neighbouring species pool by OS region
# classifyTetHabs - for classifying a neighbouring species pool by surrounding myriad


#---------------------------------------------------------------------------------------------#

#' classifying by OS region
#'
#' @param shapefile shapefile object containing monads to assess, this expects a field called 'region' in order to classify on
#' @param habType habitat type
#' @param levels data frame of the classes and proportions to classify based on surrounding neighbours
#' @param all_hab_summary species list
#' @param outfolder folder path to save the outputs
#'
#' @return
#' @export
#'
#' @examples
classifyHabs <- function(shapefile = all_monads, 
                         habType = 'heathBg',
                         levels = data.frame(cat=c("low","moderate","high"),
                                             max= c(0.1,0.25,1)),
                         all_hab_summary = 'IndicatorBaselines/Regional/all_hab_summary.csv',
                         outfolder ='IndicatorBaselines/Regional/CategorisedVectors/' ){
  
  #load in all habs summary of proportions
  propSumm <-read.csv(all_hab_summary)
  #filter to region
  hab_prop <- propSumm %>% filter(habitat == habType) %>% select(region,p1)
  hab_monad <- shapefile %>% select(monad, region, total_no=!!habType) %>% 
    mutate(total_no = ifelse(total_no == -9999, NA, total_no)) %>% 
    left_join(hab_prop,by='region') %>% mutate(valueCat=NA)
  #iterate through to classify
  for(j in levels$cat){
    lev_cat <- levels %>% filter(cat==j)
    hab_monad <- hab_monad %>% mutate({{j}} := p1*lev_cat$max) %>%
      mutate(valueCat = ifelse(is.na(valueCat) & total_no < (p1*lev_cat$max),j,valueCat))
  }
  ##plot ##
  hab_monad <- hab_monad %>% mutate(valueCat =  factor(valueCat,
                                                       levels=c("low","moderate","high"))) 
  map1 <- tm_shape(hab_monad) + tm_fill(col='valueCat', palette = "Greens", reverse=T,title = str_wrap(paste0('Botanical value - ',habType),width=10)) + tm_scale_bar(position=c("left", "bottom"))
  tmap_save(map1, paste0('D:/NE/Work/BSBI_HeatMaps/',outfolder,habType,'_regional.png'))  
  
  #write out spatial layer
  st_write(hab_monad,paste0('D:/NE/Work/BSBI_HeatMaps/',outfolder,habType,'_regional.shp'), delete_layer = T)
}

#--------------------------------------------------------------------------------------------#
#' Classify by myriad benchmarking
#'
#' @param shapefile shapefile object containing monads to assess, this expects a field called 'region' in order to classify on
#' @param region field to classify on
#' @param habType habitat type
#' @param levels data frame of the classes and proportions to classify based on surrounding neighbours
#' @param outfolder folder path to save the outputs
#'
#' @return
#' @export
#'
#' @examples
classifyTetHabs <- function(shapefile = Ind_monad_myriad, 
                            region = 'tetrad',
                            habType = 'heathBg',
                            levels = data.frame(cat=c("low","moderate","high"),
                                                max= c(0.1,0.25,1)),
                            outfolder ='IndicatorBaselines/Regional/CategorisedVectors/' ){
  
  #find unique regions
  region_cat <- shapefile  %>% st_drop_geometry()%>% select(!!region) %>% unique() 
  #iterate through hectads
  all_tetrads <- purrr::map_df(region_cat[,1],.f=function(cat){
    #monads in tetrads
    Ind_tetrad <- shapefile %>% filter(tetrad==cat) %>% 
      select(monad, RDys_40, region, !!habType, tetrad) 
    #join all species with species hab lookup
    hab_species <- all_species %>% 
      left_join(species_hab[,c('species',habType)], by='species') %>% 
      filter(get(habType) == 1) %>% 
      select(monad, species, lastRecorded)
    # get total number habitat indicators present in a hectad
    Tot_indicators <- hab_species %>% filter(monad %in% Ind_tetrad$monad) %>% 
      dplyr::select(species) %>% unique() %>% nrow()
    #class to -9999 if NA
    Ind_tetrad <- Ind_tetrad %>% rename(total_no = !!habType) %>% 
      mutate(total_no = ifelse(total_no == -9999, NA,total_no)) %>% 
      mutate(valueCat=NA, p1=Tot_indicators)
    #iterate through categories
    for(k in levels$cat){
      lev_cat <- levels %>% filter(cat==k)
      Ind_tetrad <- Ind_tetrad %>% mutate({{k}} := p1*lev_cat$max) %>%
        mutate(valueCat = ifelse(is.na(valueCat) & total_no < (p1*lev_cat$max),k,valueCat))
    }
    Ind_tetrad <-  Ind_tetrad %>% st_drop_geometry() %>% select(monad, total_no, tetrad, valueCat)
    Ind_tetrad
  })
  #left join to myriad names (tetrad notation here is a hangover from trial with tetrad, please ignore)
  out_tetrad <- Ind_monad_tetrad %>% select(monad, tetrad) %>% left_join(all_tetrads, by=c('monad','tetrad')) 
  ##plot ##
  hab_tetrad <- out_tetrad %>% mutate(valueCat =  factor(valueCat,
                                                       levels=c("low","moderate","high"))) 
  map1 <- tm_shape(hab_tetrad) + tm_fill(col='valueCat', palette = "Greens", reverse=T,title = str_wrap(paste0('Botanical value - ',habType),width=10)) + tm_scale_bar(position=c("left", "bottom"))
  tmap_save(map1, paste0('D:/NE/Work/BSBI_HeatMaps/',outfolder,habType,'_regional.png'))  
  #write out spatial layer
  st_write(out_tetrad,paste0('D:/NE/Work/BSBI_HeatMaps/',outfolder,habType,'_regional.shp'), delete_layer = T)
}

#---------------------------------------------------------------------------------------------

#' classify by moving monad window
#'
#' @param shapefile shapefile object containing monads to assess, this expects a field called 'region' in order to classify on
#' @param region monad field name
#' @param habType habitat type
#' @param levels data frame of the classes and proportions to classify based on surrounding neighbours
#' @param movingDist distance value in km of distance radius for the neighbourhood
#' @param outfolder folder path to save the outputs
#'
#' @return
#' @export
#'
#' @examples
#' 
classifyMovingWindow <- function(shapefile = Ind_monads, 
                                 region = 'monad',
                                 habType = 'heathBg',
                                 levels = data.frame(cat=c("low","moderate","high"),
                                                     max= c(0.1,0.2,1)),
                                 movingDist = neighbour_dist(25),
                                 outfolder ='IndicatorBaselines/MovingWindow/' ){
  #select monad field
  allMonads <- shapefile  %>% select(monad) 
  
  #iterate through monads to find moving hectads
  future::plan(multisession, workers = availableCores()-1)

 moving_neighbours<- future_map(1:length(allMonads$monad),.f=function(i){
    options(future.rng.onMisuse="ignore")
    set.seed(42)
    furrr_options(seed=42)
    #select monad
    monadShape <- allMonads %>% filter(monad==allMonads$monad[i]) 
    #buffer to distance
    monadBuff <- monadShape %>% suppressMessages(st_centroid()) %>% st_buffer(movingDist)
    #extract neighbouring monads
    neighbours <- allMonads[st_intersects(allMonads, monadBuff) %>% lengths > 0,]
    #join all species with species hab lookup
    hab_species <- all_species %>% 
      left_join(species_hab[,c('species',habType)], by='species') %>% 
      filter(get(habType) == 1) %>% 
      select(monad, species, lastRecorded)
    # get total number habitat indicators present in the moving neighbour window
    Tot_indicators <- hab_species %>% filter(monad %in% neighbours$monad) %>% 
      dplyr::select(species) %>% unique() %>% nrow()
    
    #change to NA and set up col names
    IndMonad <- shapefile %>% st_drop_geometry() %>% 
      select(monad, total_no = !!habType) %>% 
      filter(monad==allMonads$monad[i]) %>% 
      mutate(total_no = ifelse(total_no == -9999, NA,total_no)) %>% 
      mutate(p1=Tot_indicators,pcnt = (total_no/p1))
    IndMonad
  }, .progress=TRUE)
  
  #compile
  moving_df <-do.call(rbind.data.frame, moving_neighbours)
  
  #classify
  for(k in levels$cat){
    lev_cat <- levels %>% filter(cat==k)
    moving_df <- moving_df %>% mutate({{k}} := p1*lev_cat$max) 
  }
  moving_df <- moving_df %>% 
    mutate(valueCat = ifelse(is.na(total_no),'no indicators, poor survey coverage', 
                             ifelse(total_no==0,'no indicators,good survey coverage',
                                    ifelse(total_no<=low,'Low',
                                           ifelse(total_no<=moderate,'Moderate','High'))))) 
  
  #write out summary
  write.csv(moving_df,paste0(outfolder,habType,'.csv'))  
  
  out_hectad <- shapefile %>% select(monad) %>% left_join(moving_df[,c('monad','total_no','valueCat')], by='monad') 
  #write out spatial layer
  st_write(out_hectad,paste0(outfolder,habType,'_mw.shp'), delete_layer = T)
  
  ##plot ##
  hab_monad <- out_hectad %>% mutate(valueCat =  factor(valueCat,
                                                        levels=c('no indicators, poor survey coverage','no indicators,good survey coverage',"Low","Moderate","High"))) 
  green <- c('#afafaf','#f8f8fa',"#BAE4B3",
             "#31A354", "#006D2C")
  map1 <- tm_shape(hab_monad) + tm_fill(col='valueCat', palette = green, reverse=T,title = str_wrap(paste0('Botanical value - ',habType),width=10)) + tm_scale_bar(position=c("right", "bottom"))
  tmap_save(map1, paste0(outfolder,habType,'_mw.png'))  
  
}
