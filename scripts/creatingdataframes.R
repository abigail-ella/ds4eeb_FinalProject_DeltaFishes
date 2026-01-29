#Create a list to loop through
dfs <- list(
  trawl_76_01 = dt1,
  trawl_02_25 = dt2,
  #seine_76_25 = dt3, #not really going to use this one
  taxonomy  = dt4,
  sample_sites = dt5
)

for (nm in names(dfs)) {
  write.csv(dfs[[nm]],
            file = paste0("data/processed/", nm, ".csv"),
            row.names = FALSE)
}

#This data is all too large to save on git so it should be ignored and only saved locally -- I think?