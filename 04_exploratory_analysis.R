
# EXPLORATORY DATA ANALYSIS: Discovering Genre Personalities


library(tidyverse)
library(corrplot)

spotify_clean <- readRDS("data/processed/spotify_clean.rds")
genre_dna <- readRDS("data/processed/genre_dna.rds")


# 1. CORRELATION MATRIX - How do audio features relate?


correlation_data <- spotify_clean %>%
  select(danceability, energy, valence, tempo, loudness, 
         speechiness, acousticness, instrumentalness, liveness) %>%
  cor(use = "complete.obs")

png("output/figures/correlation_matrix.png", width = 900, height = 900, res = 120)
corrplot(correlation_data, method = "circle", type = "upper",
         tl.col = "black", tl.srt = 45,
         addCoef.col = "black", number.cex = 0.7,
         title = "Audio Feature Correlations", mar = c(0,0,2,0))
dev.off()


# 2. GENRE EXTREMES - Find the most distinctive genres


genre_extremes <- list(
  most_danceable = genre_dna %>% slice_max(avg_danceability, n = 5),
  least_danceable = genre_dna %>% slice_min(avg_danceability, n = 5),
  most_energetic = genre_dna %>% slice_max(avg_energy, n = 5),
  most_chill = genre_dna %>% slice_min(avg_energy, n = 5),
  happiest = genre_dna %>% slice_max(avg_valence, n = 5),
  saddest = genre_dna %>% slice_min(avg_valence, n = 5),
  most_popular = genre_dna %>% slice_max(avg_popularity, n = 5),
  most_acoustic = genre_dna %>% slice_max(avg_acousticness, n = 5),
  most_instrumental = genre_dna %>% slice_max(avg_instrumentalness, n = 5)
)

cat("\n=== TOP 5 MOST DANCEABLE GENRES ===\n")
print(genre_extremes$most_danceable %>% select(track_genre, avg_danceability))

cat("\n=== TOP 5 HAPPIEST GENRES (Valence) ===\n")
print(genre_extremes$happiest %>% select(track_genre, avg_valence))

cat("\n=== TOP 5 SADDEST GENRES ===\n")
print(genre_extremes$saddest %>% select(track_genre, avg_valence))

# Save extremes
saveRDS(genre_extremes, "data/processed/genre_extremes.rds")


# 3. MOOD DISTRIBUTION ACROSS GENRES


mood_by_genre <- spotify_clean %>%
  count(track_genre, mood_quadrant) %>%
  group_by(track_genre) %>%
  mutate(pct = n / sum(n) * 100) %>%
  ungroup()

write_csv(mood_by_genre, "output/tables/mood_distribution_by_genre.csv")


# 4. POPULARITY ANALYSIS - What makes a hit?


popularity_correlation <- spotify_clean %>%
  select(popularity, danceability, energy, valence, tempo, 
         loudness, speechiness, acousticness) %>%
  cor(use = "complete.obs")

cat("\n=== CORRELATION WITH POPULARITY ===\n")
print(round(popularity_correlation[1, ], 3))

# Popular vs Underground comparison
popularity_comparison <- spotify_clean %>%
  filter(popularity_tier %in% c("Chart Toppers", "Underground")) %>%
  group_by(popularity_tier) %>%
  summarise(
    avg_danceability = mean(danceability),
    avg_energy = mean(energy),
    avg_valence = mean(valence),
    avg_loudness = mean(loudness),
    avg_acousticness = mean(acousticness)
  )

cat("\n=== CHART TOPPERS vs UNDERGROUND ===\n")
print(popularity_comparison)

write_csv(popularity_comparison, "output/tables/popularity_comparison.csv")

print("Done!")
