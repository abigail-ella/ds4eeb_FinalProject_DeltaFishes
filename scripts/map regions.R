# install deltamapr one of two ways:
# option 1
options(repos = c(
  sbashevkin = 'https://sbashevkin.r-universe.dev',
  CRAN = 'https://cloud.r-project.org'))

install.packages("deltamapr")

# option 2
# install.packages("devtools")
devtools::install_github("InteragencyEcologicalProgram/deltamapr")

# load libraries
library(deltamapr)
library(ggplot2)
library(sf)

# show map of Delta regions
ggplot(R_EDSM_Strata_17P3)+
  geom_sf(aes(fill=Stratum))+
  theme_bw()
