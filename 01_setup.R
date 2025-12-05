packages <- c("tidyverse", "corrplot", "ggplot2", "viridis", 
              "patchwork", "scales", "ggridges", "factoextra",
              "ggrepel", "gganimate", "gifski")

install_if_missing <- function(pkg) {
  
  if (!require(pkg, character.only = TRUE)) {
    install.packages(pkg, dependencies = TRUE)
  }
}

sapply(packages, install_if_missing)

# Create directory structure
dirs <- c("data/raw", "data/processed", "output/figures", 
          "output/tables", "output/animations")
sapply(dirs, dir.create, recursive = TRUE, showWarnings = FALSE)

print("✓ Setup complete! Download the dataset from:")
print("https://www.kaggle.com/datasets/maharshipandya/-spotify-tracks-dataset")
print("Save as: data/raw/spotify_tracks.csv")