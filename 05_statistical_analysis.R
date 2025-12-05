# STATISTICAL ANALYSIS: Testing Genre Differences


library(tidyverse)

spotify_clean <- readRDS("data/processed/spotify_clean.rds")
genre_dna <- readRDS("data/processed/genre_dna.rds")


# 1. ANOVA: Do audio features differ significantly across genres?


# Select top 10 most popular genres for cleaner analysis
top_genres <- genre_dna %>%
  slice_max(n_tracks, n = 10) %>%
  pull(track_genre)

spotify_top <- spotify_clean %>%
  filter(track_genre %in% top_genres)

# ANOVA tests
anova_energy <- aov(energy ~ track_genre, data = spotify_top)
anova_dance <- aov(danceability ~ track_genre, data = spotify_top)
anova_valence <- aov(valence ~ track_genre, data = spotify_top)

cat("\n=== ANOVA: Energy by Genre ===\n")
print(summary(anova_energy))

cat("\n=== ANOVA: Danceability by Genre ===\n")
print(summary(anova_dance))

cat("\n=== ANOVA: Valence by Genre ===\n")
print(summary(anova_valence))


# 2. POST-HOC: Which genres differ from each other?


if(summary(anova_energy)[[1]][["Pr(>F)"]][1] < 0.05) {
  tukey_energy <- TukeyHSD(anova_energy)
  
  # Extract significant differences
  tukey_df <- as.data.frame(tukey_energy$track_genre) %>%
    rownames_to_column("comparison") %>%
    filter(`p adj` < 0.05) %>%
    arrange(desc(abs(diff)))
  
  write_csv(tukey_df, "output/tables/tukey_energy_significant.csv")
  
  cat("\n=== TOP 10 MOST DIFFERENT GENRE PAIRS (Energy) ===\n")
  print(head(tukey_df, 10))
}


# 3. T-TEST: Explicit vs Clean tracks


t_test_explicit <- t.test(energy ~ explicit, data = spotify_clean)
t_test_explicit_dance <- t.test(danceability ~ explicit, data = spotify_clean)

cat("\n=== EXPLICIT vs CLEAN: Energy ===\n")
print(t_test_explicit)

cat("\n=== EXPLICIT vs CLEAN: Danceability ===\n")
print(t_test_explicit_dance)


# 4. REGRESSION: What predicts popularity?


popularity_model <- lm(popularity ~ danceability + energy + valence + 
                         loudness + speechiness + acousticness + 
                         instrumentalness + tempo + explicit,
                       data = spotify_clean)

cat("\n=== POPULARITY PREDICTION MODEL ===\n")
print(summary(popularity_model))

# Save model summary
model_summary <- broom::tidy(popularity_model)
write_csv(model_summary, "output/tables/popularity_regression.csv")

print("✓ Statistical analysis complete!")
