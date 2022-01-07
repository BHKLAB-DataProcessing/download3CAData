out_dir <- "/pfs/out/"
# out_dir <- "~/Documents/pfs/download3CAData/"

options(timeout=6000)
data <- read.csv("https://github.com/BHKLAB-Pachyderm/download3CAData/raw/main/download_links.csv")

# download data zip file
for(i in 1:nrow(data)) {
  link <- data[i,]$download_link
  name <- data[i,]$disease
  print(paste(i, "of", nrow(data), name))
  file <- paste0(out_dir, name,".zip", sep = "")
  command <- paste("curl -L",link,">",file)
  system(command)
}