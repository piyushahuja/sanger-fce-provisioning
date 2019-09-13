mkdir -p /software/team170/Rlib # or R-3.5.1/library

cd ~ && singularity shell singularity-rstudio-seurat.simg
# This ensures that the Seurat and others installations arein the right place.
export R_LIBS ='/software/team170/Rlib'
# open R and check .libPaths(), then:

install.packages('Seurat')
install.packages("tidyverse", dependencies=TRUE)

pkgs <- c(
'reticulare'
'limma',
'reshape2',
'ggplot2',
'broom',
'magrittr',
'dplyr',
'tidyr',
'purrr',
'broom',
'stringr',
'tibble',
'readr',
'openxlsx',
'dendextend',
'RColorBrewer',
'gplots',
'genefilter',
'remotes',
'biomaRt')

# This is to ensure the right version of Python is used
# 
# use_condaenv("/software/team170/miniconda3/")
# Sys.setenv(RETICULATE_PYTHON="/software/team170/miniconda3/bin/python")
# Sys.setenv(PYTHON_PATH="/software/team170/miniconda3/lib/python3.7")
# Sys.setenv(PYTHONPATH="/software/team170/miniconda3/lib/python3.7")


ap.db <- available.packages(contrib.url(BiocManager::repositories()))
ap <- rownames(ap.db)
fnd <- pkgs %in% ap
pkgs_to_install <- pkgs[fnd]

ok <- BiocManager::install(pkgs_to_install, update=FALSE, ask=FALSE) %in%
    rownames(installed.packages())

if (!all(fnd))
    message("Packages not found in a valid repository (skipped):\n  ",
            paste(pkgs[!fnd], collapse="  \n  "))
if (!all(ok))
    stop("Failed to install:\n  ",
         paste(pkgs_to_install[!ok], collapse="  \n  "))

suppressWarnings(BiocManager::install(update=TRUE, ask=FALSE))
remotes::install_github("vqv/ggbiplot",
    upgrade = 'never', force = TRUE, quiet = TRUE)




