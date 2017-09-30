#' get_monadic_data
#'
#' This function saves in your globalenvironment painel monadyc data using country-year as
#' units of analysis. This merged dataset is generating from a joining some sommonly used
#' data in IR, such as PolityIV, Cinc, COW, UCDP, TRADE.
#'
#' @param data a character with one argument: monadic.
#' @param adding
#' @usage get_monadic_data(data="monadic")
#' @return returns a data.frame automatically saved in the global enviroment.
#' @examples
#' get_monadic_data("monadic")
#' @export

get_merged_data <- function(data){
  if(data=="Monadic"){
    #Pull data frame from COW
    #This forms the skeleton of the data fram
    system<-read.csv(url("http://www.correlatesofwar.org/data-sets/state-system-membership/system2016/at_download/file/system2016.csv"))

    #Pull monadic level data
    #Polilty
    polity<-read.table("http://privatewww.essex.ac.uk/~ksg/data/ksgp4use.asc", header=TRUE)

    #CINC data
    temp <- tempfile()
    download.file("http://www.correlatesofwar.org/data-sets/national-material-capabilities/nmc-v5-1/at_download/file/NMC_5_0.zip",temp)
    cinc<- read.csv(unz(temp, "NMC_5_0.csv"))
    unlink(temp)

    #Civil War Data
    #UCDP Monadic Conflict Onset Dataset
    UCDPMondadic<-read.csv(url("http://ucdp.uu.se/downloads/monadterm/ucdp-onset-conf-2014.csv"))

    #Kristian Gleditschas Expanded Trade and GDP data
    temp <- tempfile()
    download.file("http://privatewww.essex.ac.uk/~ksg/data/exptradegdpv4.1.zip",temp)
    Trade_GDP<- read.table(unz(temp, "pwt_v61.asc"), header=TRUE)
    unlink(temp)

    #Get MID Data
    MIDS<-read.csv(url("http://vanity.dss.ucdavis.edu/~maoz/dyadmid20.csv"))


    polity_data.t <- polity %>%
      dplyr::select(.,POLITY, CCODE, YEAR) %>%
      dplyr::rename(.,democ=POLITY, year=YEAR, ccode =CCODE) %>%
      dplyr::mutate(., democ=ifelse(democ< -10, NA, democ))

    cinc_data.t <- cinc %>%
      dplyr::select(., cinc, ccode, year) %>%
      dplyr::rename(cincscore=cinc)

    mid_data.t <- MIDS %>%
      dplyr::select(YEAR, HIHOST, STATEA, STATEB) %>%
      dplyr::rename(year=YEAR, hostility=HIHOST, ccodeA=STATEA, ccodeB=STATEB) %>%
      dplyr::mutate(dyadid=as.character(year*1000000+ccodeA*1000+ccodeB))


    UCDPMondadic.t <- UCDPMondadic %>%
      dplyr::mutate(ccode=gwno)

    Trade_GDP.t <- Trade_GDP %>%
      dplyr::mutate(ccode=statenum)


    # Merging

    dataOrig<-system[c(2,3,1)]

    dataOrig.t <- dataOrig %>%
      dplyr::left_join(cinc_data.t) %>%
      dplyr::left_join(polity_data.t) %>%
      dplyr::left_join(UCDPMondadic.t) %>%
      dplyr::left_join(Trade_GDP.t)

    assign("df.mono", dataOrig.t, .GlobalEnv)

  }
}

