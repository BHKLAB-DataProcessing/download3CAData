library(readr)
library(tools)

# out_dir <- "/pfs/out/"
out_dir <- "~/Documents/pfs/download3CAData/"

options(timeout=6000)
data <- read_csv("./download_links.csv")