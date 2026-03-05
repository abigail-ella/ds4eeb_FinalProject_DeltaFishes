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

# check CRS
st_crs(R_EDSM_Strata_17P3)

# read df of sites and lat/lon
# 'selected_sites' can also be obtained using the code from 'seine data.qmd'
selected_sites <- read_rds("~/Documents/projects/ds4eeb/Pete_local_data/selected_sites.rds")

# convert my df of seine sites to sf format
selected_sites_sf <- 
  st_as_sf(
  selected_sites,
  coords = c("longitude", "latitude"), 
  crs = 4326 # WGS84 lat/lon
  )

# assuming that it's projected, transform my points
selected_sites_sf <- st_transform(
  selected_sites_sf,
  st_crs(R_EDSM_Strata_17P3)
  )

# add seine locations to the map
ggplot(R_EDSM_Strata_17P3) +
  geom_sf(aes(fill = Stratum)) +
  geom_sf(data = selected_sites_sf,
          color = "red",
          size = 3) +
  theme_bw()

# hmmm! suggests multiple responses! possibly, there's something amiss with the 
# projection and that's why the seine sites include locations well outside of
# the base map. I think it's more likely that the sites I've selected include 
# several well N of Sacramento, a couple in the SJR, and several more in SF Bay.
# Unfortunately, I did not include sites in Suisun Bay or the western Delta...
# possibly because these haven't been sampled as regularly (they could've just 
# missed the cut-off). No surprise that there's nothing in the Yolo Bypass/DWSC 
# or Cache Slough...