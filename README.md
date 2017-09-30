# GetIRdata
**GetIRdata**: Download and Merge data commonly used in the International Relations research 

GetIRdata creates three functions with the goal of making the download and the merging process of datasets commonly used by the academic community in International Relation more automatic and less time-consuming. GetIRdata was created as a result of the graduate seminar course _New Methods for the study of Conflicts_ coordinate by Professores David Cunnigham and William Reed in the Department of Government and Politics at University of Maryland, College Park

## Functions

GetIRdata has three function:

`get_each_data`: Returns a basic IR dataset saved in one's global environment. The avaliable datasets now for download are:

- PolityIV ("PolityIV"), 

- The National Material Capabilities from the Correlates of War Project ("CINC"),

- The Country-Code system from the Correlates of War Project ("COW")

- The UCDP data on Conflict Onset ("UCDP")

- The dataset onf trade flow from Professor Kristen Gledistch ("Trade")

- The Dyadic Militarized Interstate Disputes Dataset from Professor Zeev Maoz ("MID"). 

*The arguments for this function are the names in parentesis*

`get_monadyc_data`: Returns a monadyc data merging all the datasets above mentioned except for the MID data, using the the COW code as the skeleton of the data.

`get_dyadic_data`: Returns a dyadic skeleton formed by painel country-year dataset from 1816 to 2016. It also merges this skeleton with the data from MID, Polity and CINC, using the COW code as the country ID. The function has two argument: "dyadic_dir" for direct dyads and "dyadic_indir" for indirect dyads between the countryes. 

## Installation

You can install the most recent development version of `GetIRdata` using the devtools package. First, you need to install the devtools package with the following code:

```
if(!require(devtools)) install.packages("devtools")
```

Then you need to load devtools and install GetIRdata from its GitHub repository:

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

- **Saving a monadic country-year painel data**

```
get_monadic_data("Monadic")
```

- **Saving a dyadic direct country-year painel data**

```
get_dyadic_data("dyadic_dir")
```

## Contributions

`GetIRdata` was developed by [Tiago Ventura](https://github.com/TiagoVentura) with contributtion of William Reed and David Cunnigham. Feedback and comments are most welcome.



