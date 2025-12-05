
# DATA PREPROCESSING & FEATURE ENGINEERING


library(tidyverse)

spotify_raw <- readRDS("data/raw/spotify_raw.rds")


spotify_clean <- spotify_raw %>%
  distinct(track_id, .keep_all = TRUE) %>%
  filter(!is.na(danceability), !is.na(energy), !is.na(valence), !is.na(tempo)) %>%
  mutate(
    duration_min = duration_ms / 60000,
    tempo_category = case_when(
      tempo < 80 ~ "Slow",
      tempo < 120 ~ "Moderate",
      tempo < 150 ~ "Upbeat",
      TRUE ~ "Fast"
    ),
    energy_level = case_when(
      energy < 0.33 ~ "Chill",
      energy < 0.66 ~ "Moderate",
      TRUE ~ "Intense"
    ),
    mood_score = (valence + energy) / 2,
    
    # Yeh check kar le (sabhi)
    mood_quadrant = case_when(
      valence >= 0.5 & energy >= 0.5 ~ "Happy & Energetic",
      valence >= 0.5 & energy < 0.5 ~ "Peaceful & Positive",
      valence < 0.5 & energy >= 0.5 ~ "Angry & Turbulent",
      TRUE ~ "Sad & Quiet"
    ),
    popularity_tier = case_when(
      popularity >= 75 ~ "Chart Toppers",
      popularity >= 50 ~ "Mainstream",
      popularity >= 25 ~ "Rising",
      TRUE ~ "Underground"
    ),
    
    acoustic_electronic = acousticness - (1 - acousticness),
    
    vocal_presence = 1 - instrumentalness
  ) %>%
  
  # Convert to factors (error de raha hai!)
  mutate(
    tempo_category = factor(tempo_category, levels = c("Slow", "Moderate", "Upbeat", "Fast")),
    energy_level = factor(energy_level, levels = c("Chill", "Moderate", "Intense")),
    popularity_tier = factor(popularity_tier, levels = c("Underground", "Rising", "Mainstream", "Chart Toppers")),
    mood_quadrant = factor(mood_quadrant)
  )

# Create genre-level summary (the "DNA" of each genre) (also error)
genre_dna <- spotify_clean %>%
  group_by(track_genre) %>%
  summarise(
    n_tracks = n(),
    avg_popularity = mean(popularity, na.rm = TRUE),
    avg_danceability = mean(danceability, na.rm = TRUE),
    avg_energy = mean(energy, na.rm = TRUE),
    avg_valence = mean(valence, na.rm = TRUE),
    avg_tempo = mean(tempo, na.rm = TRUE),
    avg_loudness = mean(loudness, na.rm = TRUE),
    avg_speechiness = mean(speechiness, na.rm = TRUE),
    avg_acousticness = mean(acousticness, na.rm = TRUE),
    avg_instrumentalness = mean(instrumentalness, na.rm = TRUE),
    avg_liveness = mean(liveness, na.rm = TRUE),
    avg_duration = mean(duration_min, na.rm = TRUE),
    pct_explicit = mean(explicit, na.rm = TRUE) * 100,
    # Standard deviations for variability
    sd_energy = sd(energy, na.rm = TRUE),
    sd_valence = sd(valence, na.rm = TRUE),
    # Dominant mood
    dominant_mood = names(which.max(table(mood_quadrant)))
  ) %>%
  ungroup()


saveRDS(spotify_clean, "data/processed/spotify_clean.rds")
saveRDS(genre_dna, "data/processed/genre_dna.rds")
write_csv(genre_dna, "data/processed/genre_dna.csv")

cat("\n=== PREPROCESSING COMPLETE ===\n")
cat("Clean tracks:", nrow(spotify_clean), "\n")
cat("Genres profiled:", nrow(genre_dna), "\n")
print(head(genre_dna))
