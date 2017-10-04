# GetIRdata
**GetIRdata**: Download and Merge data often used in the International Relations research 

`GetIRdata` has three functions with the goal of making the download and the merging process of datasets often employed by the academic community in International Relation more automatic and less time-consuming. 

`GetIRdata` was created as a suggestion during the graduate seminar  _New Methods for the study of Conflicts_ coordinate by Professors David Cunnigham and William Reed in the Department of Government and Politics at University of Maryland, College Park

## Functions

`GetIRdata` has three functions:

`get_each_data`: Returns a basic IR dataset saved in one's R global environment. The available datasets for download now are the following and the arguments to call them in the function are in parenthesis:

- PolityIV ("PolityIV"), 

- The National Material Capabilities from the Correlates of War Project ("CINC"),

- The Country-Code system from the Correlates of War Project ("COW")

- The UCDP data on Conflict Onset ("UCDP")

- The dataset of trade flow from Professor Kristen Gleditsch ("Trade")

- The Dyadic Militarized Interstate Disputes Dataset from Professor Zeev Maoz ("MID"). 


`get_monadyc_data`: Returns a monadic data merging all the datasets above mentioned except for the MID data, using the COW code as the skeleton of the data.

`get_dyadic_data`: Returns a dyadic skeleton formed by panel country-year dataset from 1816 to 2016. It also merges this skeleton with the data from MID, PolityIV and CINC, using the COW code as the country ID. The function has two arguments: "dyadic_dir" for direct dyads and "dyadic_indir" for indirect dyads between the countries. 

## Installation

You can install the most recent development version of `GetIRdata` using the devtools package. First, you need to install the devtools package with the following code:

```
if(!require(devtools)) install.packages("devtools")
```

Then you need to load devtools and install GetIRdata from its [GitHub repository](https://github.com/TiagoVentura/GetIRdata):

```
library(devtools)
devtools::install_github("TiagoVentura/GetIRdata")
```

## Usage

`GetIRdata` is quite simple to use. The package contains only three functions, with each of them with few arguments. The logic for the three function is the same: one should add a character argument to specify which dataset, or type of merge data, one wants to save in the .globalenvironment. 

- **Saving the PolityIV data.**

```
get_each_data("PolityIV)
```

- **Saving a monadic country-year panel data**

```
get_monadic_data("Monadic")
```

- **Saving a dyadic directed country-year data**

```
get_dyadic_data("dyadic_dir")
```

## Contributions

`GetIRdata` was developed by [Tiago Ventura](https://github.com/TiagoVentura) with contributions of William Reed and David Cunnigham. Feedback and comments are most welcome.

## See Also 

Above one can find the weblinks for each of the base datasets available to download through  `GetIRdata` functions

- [PolityIV](http://privatewww.essex.ac.uk/~ksg/polity.html)
- [COW Country Codes](http://www.correlatesofwar.org/data-sets/state-system-membership)
- [CINC](http://www.correlatesofwar.org/data-sets/national-material-capabilities)
- [UCDP ONSET](http://ucdp.uu.se/downloads/)
- [Trade Flow](http://privatewww.essex.ac.uk/~ksg/exptradegdp.html)
- [MID](http://vanity.dss.ucdavis.edu/~maoz/datasets.htm)

