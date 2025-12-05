
# DATA LOADING & INITIAL EXPLORATION


library(tidyverse)


spotify_raw <- read_csv("data/raw/spotify_tracks.csv")


cat("\n=== DATASET OVERVIEW ===\n")
cat("Total tracks:", nrow(spotify_raw), "\n")
cat("Total genres:", n_distinct(spotify_raw$track_genre), "\n")
cat("Columns:", ncol(spotify_raw), "\n\n")


print(names(spotify_raw))


glimpse(spotify_raw)


saveRDS(spotify_raw, "data/raw/spotify_raw.rds")

print("Data loaded successfully!") # reload kar le agar nahi chal raha toh
