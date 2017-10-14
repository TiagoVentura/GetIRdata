#' get_dyadic_data
#'
#' \code{get_dyadic_data} Returns a panel data formed by Country-dyads from 1816 to 2016.
#' Beyond the dyads, the dataset also combines variables from Polity, CINC, and MIDS.
#' The dataset uses COW code as the country ID. Id values for the dyads are also provided.
#' Finally, one can ask for direct or indirect dyads.
#' @importFrom magrittr '%>%'
#' @param \code{data} a character with two arguments: "dyadic_dir" and "dyadic_indir".
#' \itemize{
#' \item \code{dyadic_dir} Returns a direct dyadic data.
#' \item \code{dyadic_indir} Returns a indirect dyadic data.
#' @usage get_dyadic_data(data="dyadic_dir")
#' @return returns a data.frame in the global enviroment.
#' @examples
#' get_dyadic_data("dyadic_dir")
#' @export

get_dyadic_data <- function(data){

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
      dplyr::mutate(dyadid=as.character(year*100+ccodeA*100+ccodeB))


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

    dataOrig.r <- dataOrig.t %>% dplyr::select(ccode, year, cincscore, democ)

    if(data=="dyadic_dir"){

    df <- dataOrig.t %>% dplyr::select(ccode) %>% dplyr::mutate(ccode_rec= ccode)

    df <- df %>% tidyr:::expand(.,statea=ccode, stateb=ccode_rec, year=seq(1816,2016)) %>%
      dplyr::filter(statea!=stateb)%>%
      dplyr::left_join(., dataOrig.r, by=c("statea"="ccode", "year")) %>%
      dplyr::left_join(., dataOrig.r, by=c("stateb"="ccode", "year")) %>%
      dplyr::mutate(dyadid = as.character(year*100 + statea*100 + stateb)) %>%
      dplyr::rename(year=year, ccodeA=statea, ccodeB=stateb, cincA=cincscore.x,
             democA=democ.x, cincB=cincscore.y, democB=democ.y)

    df <- df %>% dplyr::left_join(mid_data.t)


     assign("df.dyadic_direct", df, .GlobalEnv)

    } else if (data=="dyadic_indir") {


      # Function to create combination without repetitions

      expand.grid.unique <- function(x, y, include.equals=TRUE){
        x <- unique(x)

        y <- unique(y)

        g <- function(i)
        {
          z <- setdiff(y, x[seq_len(i-include.equals)])

          if(length(z)) cbind(x[i], z, deparse.level=0)
        }

        do.call(rbind, lapply(seq_along(x), g))
      }

      ccode <- unique(dataOrig.t$ccode)
      ccode2 <- unique(dataOrig.t$ccode)
      df.indir <- expand.grid.unique(ccode, ccode2)
      df.indir <- as.data.frame(df.indir)

      df.indir <- df.indir %>% dplyr::filter(V1!=V2) %>%
        dplyr::mutate(., id = V1*1000 + V2, year.start=1816, year.end=2016)

  # Expanding the years

      df.skeleton <- df.indir %>%
                    dplyr::rowwise() %>%
                    dplyr::do(data.frame(id = .$id, year = seq(.$year.start, .$year.end, by = 1)))



  # Merging

        df <- df.skeleton %>%
        dplyr::left_join(., df.indir, by="id") %>%
        dplyr::left_join(., dataOrig.r, by=c("V1"="ccode", "year")) %>%
        dplyr::left_join(., dataOrig.r, by=c("V2"="ccode", "year")) %>%
        dplyr::rename (dyadid=id , year=year, ccodeA=V1, ccodeB=V2, cincA=cincscore.x,
                       democA=democ.x, cincB=cincscore.y, democB=democ.y) %>%
        dplyr::select(-year.start, -year.end)

  # I did in this way because in the pipe above it was taking a long time.

        df$dyadid <- as.character(df$year*100 + df$ccodeA*100 + df$ccodeB)


        df <- df %>% dplyr::left_join(mid_data.t)

          assign("df.dyadic_indir", df, .GlobalEnv)


    } else{
    warning("Add the name of the dataset you are calling")
  }

}




