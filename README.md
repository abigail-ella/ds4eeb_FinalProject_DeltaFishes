# README
Ward, A.

## Project Summary

#### Title: Sacramento–San Joaquin Delta Environmental and Fish Community Analysis

This final project within the BIOE 276 Data Science for EEB course
attempts to analyzes long term changes in temperature and salinity
within the Sacramento–San Joaquin Delta and assesses how those
environmental changes have contributed to overall changes in fish
community assemblages. Using data from the Delta Juvenile Fish
Monitoring Program Environmental Data Initiative (EDI), we explore these
specific environmental trends over time and associations with fish
species composition.

#### Research Questions/ Objectives

Our project is looking to understand the long term changes to important
environmental variables within the Sacramento–San Joaquin Delta. We want
to understand the impacts of these shifts on fish community assemblages
over time. Possible objectives include:

- Analyze shifts in temperature and salinity over time
- Assess changes in species composition, abundance, and distribution
- Look at correlations between patterns of fish communities and
  environmental condition changes to understand potential ecological
  responses
- Compare the seasonal composition of fish communities in discrete parts
  of the Delta
- Quantify the environmental predictability associated with water
  temperature, salinity, turbidity and flow from discrete parts of the
  Delta
- Map year-to-year changes in environmental conditions across the Delta
- Track phenology of salmonid outmigration over time and during
  different water year types (for example, how does juvenile salmon
  transit time between Delta entry at Sacramento and Mossdale and Delta
  exit at Chipps Island vary from one year to the next?) *Prediction:
  Delta passage times will be slowest during water years characterized
  by intermediate flow (or precipitation) rates and faster under
  conditions of high flow (early departure from natal streams and travel
  facilitated by current speed) and under conditions of low flow (some
  juveniles delay outmigration due to slower growth rates coupled with
  reduced travel rates associated with slower current speeds).* This is
  going to be complicated by multiple run-types having differing run
  timing.
- Is Silverside (*Menidia audens*) abundance correlated with
  environmental predictability? Is a short-lived fish subject to a
  variable that is defined over decades? What about a long-lived
  species?

#### Background Information

The Delta Juvenile Fish Monitoring Program (DJFMP) includes several
long-term fish monitoring projects within the Sacramento-San Joaquin
Delta and San Francisco Bay. Initially established in 1978 to monitor
juvenile fall-run Chinook Salmon (*Oncorhynchus tshawytscha*) abundance,
the program now includes efforts to monitor all four Chinook run-types,
as well as Steelhead (*O. mykiss*), Delta Smelt (*Hypomesus
transpacificus*), Striped Bass (*Morone saxatilis*) and other resident
and migratory fishes. Environmental data too are collected as a part of
this effort.

ADD MORE HERE about the background information of both DJFMP and how
this data is influencing our motivating question. Also discuss a target
audience in bold

#### Target Audience

Our immediate audience is comprised of our classmates and our professor
for the UCSC ES4EEB course, but our hope is that we will find compelling
patterns in our data and evidence for significant ecological processes.
In that event, we plan to continue our data exploration and analyses
with the goal of publishing a paper on our findings, perhaps in San
Francisco Estuarine and Watershed Sciences.

## Repository Summary

#### Directory Structure

`/dds4eeb_FinalProject_DeltaFishes/`

`├── data/ # Raw and processed data`

`├── scripts/ # R scripts and markdown files`

`├── figures/ # Output plots and figures`

`├── outputs/ # Results, tables, and exports`

`├── docs/ # Documentation, notes, and resources`

`├──README.qmd/ #Project and workflow description file`

`└── BIOE 176 dds4eeb_FinalProject_DeltaFishes.Rproj # RStudio project file`

#### Data Sources

All data used in this project is from the Delta Juvenile Fish Monitoring
Program (DJFMP) Environmental Data, accessed via the Environmental Data
Initiative (EDI -
<https://portal.edirepository.org/nis/mapbrowse?scope=edi&identifier=244>).
Sampling locations are spread throughout the Sacramento–San Joaquin
River Delta and span decades as monitoring has occurred from 1976 to
present day. This program has monitored abundance and distribution of
fish species utilizing both trawls and beach seines. Monitoring also
include environmental data at all sites.

Data used in this analysis was filtered to focus specifically on trawl
survey data during the fall season. Here, we focus on two key water
quality parameters measured within this data: temperature and salinity.

Raw data were downloaded as CSV files and stored in
the `data/` directory. Processed data used for analysis are generated
via scripts in the `scripts/` directory.

#### Installation/ Setup

Run `data/raw/edi.244.14.r` to retrieve raw data from EDI repository.

In `.gitignore` run `data/processed/*.csv` and commit this change as
ignoring our processed data files. These files are too large and must
only be stored locally.

Then run `scripts/creatingdataframes.R` to regenerate these dataframes
locally in R.

ADD MORE HERE about data access, packages needed, cloning the repo, etc.

#### Workflow

##### Explore

Initially, we expect to process our data, asking questions, and
generating figures. Most of this will be done individually, albeit with
mutual support for technical questions and some discussion regarding
what we are seeing. There should be a good deal of data wrangling and
cleaning at this stage, eliminating, too, what seems extraneous. Initial
ideas about data analysis should begin to emerge. This is likely to be
coupled with reading from the published literature, although the amount
of time available probably is going to limit this.

Our research questions are expected to “lead to a specific statistical
analysis plan” (Popovic et al. 2024) for each. Consider adopting a
risk-of-bias assessment tool (see Boyd et al. 2022) and registering
(*sensu* Popovic et al. 2024) a description of our study with Malin
(sort of an informal registration).

##### Refine

Early discoveries should lead to the development of some testable
hypotheses and increased discussion among team members. What seems
interesting? Tractable? How might different questions and components fit
together? We expect that this phase should include the identification of
strategies for analysis, and writing code with the expectation that
others are going to run and read that code. This phase is also going to
demand that we articulate our questions and hypotheses more formally,
now working more closely together. Effective communication is going to
be even more important.

##### Produce

At this point, with due dates closing in, we expect to execute our code,
polishing our figures and developing slides for presenting our results
to our classmates.

ADD MORE HERE about what each script we have does, content available for
data import and cleaning, looking at maps of environmental trends, and
then fish community analysis. Also, it’d be good to flesh-out plans for
using and tending our GitHub repo. We will want to keep it well
organized (like Abbie created it!) so that it too is something that we
can share with Malin and our classmates.

ALSO: let’s add a timeline in here, so we know *what* things are due and
*when*!

#### References

Boyd, R. J., Powney, G. D., Burns, F., Danet, A., Duchenne, F.,
Grainger, M. J., Jarvis, S. G., Martin, G., Nilsen, E. B., Porcher, E.,
Stewart, G. B., Wilson, O. J., & Pescott, O. L. (2022). ROBITT: A tool
for assessing  
the risk-of-bias in studies of temporal trends in ecology. Methods in
Ecology and Evolution, 13(7), 1497–1507. https:// doi.org/10.1111/2041-
210X.13857

Popovic, Gordana, Tanya Jane Mason, Szymon Marian Drobniak, et al. “Four
Principles for Improved Statistical Ecology.” *Methods in Ecology and
Evolution* 15 (2024): 266–81. <https://doi.org/10.1111/2041-210X.14270>.

United States Fish and Wildlife Service, J. Speegle, C. Macfarlane, E.
Huber, D. Goodman, K. Erly, and R. Cook. 2026. Interagency Ecological
Program: Over four decades of juvenile fish monitoring data from the San
Francisco Estuary, collected by the Delta Juvenile Fish Monitoring
Program, 1976-2025 ver 14. Environmental Data Initiative.
https://doi.org/10.6073/pasta/ad35c80cafd87ba928d3f37fa124ccaf (Accessed
2026-01-28).

Wang, Yi, Ulrike Naumann, Stephen T. Wright, and David I. Warton.
“mvabund– an R Package for Model-Based Analysis of Multivariate
Abundance Data.” *Methods in Ecology and Evolution* 3, no. 3 (2012):
471–74. <https://doi.org/10.1111/j.2041-210X.2012.00190.x>.

Warton, David I., Mitchell Lyons, Jakub Stoklosa, and Anthony R. Ives.
“Three Points to Consider When Choosing a LM or GLM Test for Count
Data.” *Methods in Ecology and Evolution* 7, no. 8 (2016): 882–90.
<https://doi.org/10.1111/2041-210X.12552>.

<https://iep.ca.gov/Science-Synthesis-Service/Monitoring-Programs/Delta-Juvenile-Fish>

<https://r.geocompx.org/adv-map>
