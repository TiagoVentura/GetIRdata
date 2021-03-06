#' get_each_data
#'
#' \code{get_each_data} automatically saves a dataset in your globalenvironment.
#' Using this function, one can easily download a variety of popular datasets in International Relations.
#'
#' @param \code{data} The name of the data to be downloaded (character). For this function, this paramater
#' assumes the following values.
#' \itemize{
#' \item \code{PolityIV}  Returns the Polity IV dataset
#' \item \code{COW}  Returns the Country-Code system from the Correlates of War Project
#' \item \code{CINC} Returns the National Material Capabilities from the Correlates
#' of War Project
#' \item \code{UCDP} Returns the UCDP data on Conflict Onset
#' \item \code{Trade} Returns the dataset onf trade flow from Professor Kristen Gledistch
#' \item \code{MID} Returns the Dyadic Militarized Interstate Disputes Dataset from Professor Zeev Maoz}
#' @details PolityIV: Returns the Polity Data.
#' @usage get_each_data(data="name of the data")
#' @return returns a data.frame automatically saved in the .global enviroment.
#' @examples
#' get_each_data("PolityIV")
#' @export

get_each_data <- function(data){
  # Geting Cow
  if (data == "COW" ){
    cow <-read.csv(url("http://www.correlatesofwar.org/data-sets/state-system-membership/system2016/at_download/file/system2016.csv"))
    assign("Cow",cow,.GlobalEnv)
  } else if (data == "PolityIV"){
    polity<-read.table("http://privatewww.essex.ac.uk/~ksg/data/ksgp4use.asc", header=TRUE)
    assign("PolityIV",polity,.GlobalEnv)
  } else if ( data =="CINC") {
    temp <- tempfile()
    download.file("http://www.correlatesofwar.org/data-sets/national-material-capabilities/nmc-v5-1/at_download/file/NMC_5_0.zip",temp)
    cinc <- read.csv(unz(temp, "NMC_5_0.csv"))
    unlink(temp)
    assign("cinc",cinc,.GlobalEnv)
  } else if(data =="UCDP") {
    UCDPMondadic<-read.csv(url("http://ucdp.uu.se/downloads/monadterm/ucdp-onset-conf-2014.csv"))
    assign("UCDP",UCDPMondadic,.GlobalEnv)
  } else if (data =="Trade") {
    temp2 <- tempfile()
    download.file("http://privatewww.essex.ac.uk/~ksg/data/exptradegdpv4.1.zip",temp2)
    Trade_GDP<- read.table(unz(temp2, "pwt_v61.asc"), header=TRUE)
    unlink(temp2)
    assign("Trade", Trade_GDP, .GlobalEnv)
  } else if (data=="MID"){
    MIDS<-read.csv(url("http://vanity.dss.ucdavis.edu/~maoz/dyadmid20.csv"))
    assign("Mid", MIDS, .GlobalEnv)
  }else{
    warning("Add the name of the dataset you are calling")
  }
}

