library(SummarizedExperiment)
library(readr)
library(tools)

# out_dir <- "/pfs/out/"
out_dir <- "~/Documents/pfs/get3CA/"

options(timeout=6000)
data <- read_csv("./download_links.csv")

# setwd(out_dir)
link <- data[1,]$download_link
name <- data[1,]$disease
dir_name <- paste0(out_dir, name)
dir.create(dir_name)
# setwd(paste("./",name,sep = ""))

# download data zip file 
file <- paste0(dir_name, "/", name,".zip", sep = "")
command <- paste("curl -L",link,">",file)
system(command)

# unzip 
suppressWarnings(unzip(file, exdir=dir_name))

# parse into SummarizedExperiment object and save as .rds file.
files <- list.files(path = dir_name, pattern = "Exp")
matrix <- Matrix::readMM(paste0(dir_name, "/", files[1]))
cols <- data.table::fread(paste0(dir_name, "/", "Cells.txt"))
# new_list <- list(SummarizedExperiment(assays = matrix,colData = cols$cell_name))
saveRDS(SummarizedExperiment(assays = matrix,colData = cols$cell_name), paste0(out_dir, name, ".rds"))

# colnames <- c(name)
# setwd(out_dir)
for(i in 2:nrow(data)) {
  link <- data[i,]$download_link
  name <- data[i,]$disease
  dir_name <- paste0(out_dir, name)
  dir.create(dir_name)
  # setwd(paste("./",name,sep = ""))
  
  file <- paste0(dir_name, "/", name,".zip", sep = "")
  command <- paste("curl -L",link,">",file)
  system(command)
  suppressWarnings(unzip(file, exdir=dir_name))
  
  dirs <- list.dirs(dir_name)
  if (length(dirs) > 1) {
    for (dir in dirs) {
      # setwd(dir)
      # files <- list.files(pattern = "Exp")
      # files <- c(files, list.files(pattern = "exp"))
      # cells <- list.files(pattern = "Cells")
      # cells <- c(cells, list.files(pattern = "cell"))
      # sub_dir_name <- paste0(dir_name, "/", dir)
      files <- list.files(path = dir, pattern = "exp", ignore.case = TRUE)
      cells <- list.files(path = dir, pattern = "cell", ignore.case = TRUE)
      if (length(files) >= 1) {
        names <- strsplit(dir,"/")
        new_name <- paste0(name, "_", names[[1]][length(names[[1]])])
        if (file_ext(files[1]) == "mtx") {
          matrix <- Matrix::readMM(paste0(dir, "/", files[1]))
        }
        if (file_ext(files[1]) == "rds") {
          matrix <- readRDS(paste0(dir, "/", files[1]))
        }
        cols <- suppressWarnings(data.table::fread(paste0(dir, "/", cells[1])))
        if ("cell_name" %in% names(cols)) {
          # exp <- SummarizedExperiment(assays = matrix,colData = cols$cell_name)
          saveRDS(SummarizedExperiment(assays = matrix,colData = cols$cell_name), paste0(out_dir, new_name, ".rds"))
        }
        if ("Cell_names" %in% names(cols)) {
          # exp <- SummarizedExperiment(assays = matrix,colData = cols$Cell_names)
          saveRDS(SummarizedExperiment(assays = matrix,colData = cols$Cell_names), paste0(out_dir, new_name, ".rds"))
        }
        # new_list <- append(new_list,exp)
        # colnames <- c(colnames,new_name)
      }
    }
  }
  else {
    # files <- list.files(pattern = "Exp")
    # files <- c(files,list.files(pattern = "exp"))
    # cells <- list.files(pattern = "Cells")
    # cells <- c(cells,list.files(pattern = "cell"))
    files <- list.files(path = dir_name, pattern = "exp", ignore.case = TRUE)
    cells <- list.files(path = dir_name, pattern = "cell", ignore.case = TRUE)
    if (file_ext(files[1]) == "mtx") {
      matrix <- Matrix::readMM(paste0(dir_name, "/", files[1]))
    }
    if (file_ext(files[1]) == "rds") {
      matrix <- readRDS(paste0(dir_name, "/", files[1]))
    }
    cols <- suppressWarnings(data.table::fread(paste0(dir_name, "/", cells[1])))
    if ("cell_name" %in% names(cols)) {
      # exp <- SummarizedExperiment(assays = matrix,colData = cols$cell_name)
      saveRDS(SummarizedExperiment(assays = matrix,colData = cols$cell_name), paste0(out_dir, name, ".rds"))
    }
    if ("Cell_names" %in% names(cols)) {
      # exp <- SummarizedExperiment(assays = matrix,colData = cols$Cell_names)
      saveRDS(SummarizedExperiment(assays = matrix,colData = cols$Cell_names), paste0(out_dir, name, ".rds"))
    }
    # new_list <- append(new_list,exp)
    # colnames <- c(colnames,name)
  }

  # setwd(out_dir)
}

# names(new_list) <- colnames

