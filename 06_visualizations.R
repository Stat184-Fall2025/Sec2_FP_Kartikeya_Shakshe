
# VISUALIZATIONS: The Art of Sound


library(tidyverse)
library(ggplot2)
library(viridis)
library(patchwork)
library(scales)
library(ggridges)
library(ggrepel)

spotify_clean <- readRDS("data/processed/spotify_clean.rds")
genre_dna <- readRDS("data/processed/genre_dna.rds")

# Theme
theme_set(theme_minimal(base_size = 12) +
            theme(plot.title = element_text(face = "bold", size = 14)))

# Select featured genres for clearer plots
featured_genres <- c("pop", "rock", "hip-hop", "jazz", "classical", 
                     "electronic", "r-n-b", "country", "metal", "indie")

spotify_featured <- spotify_clean %>% filter(track_genre %in% featured_genres)
genre_dna_featured <- genre_dna %>% filter(track_genre %in% featured_genres)


# 1. GENRE MOOD MAP - Valence vs Energy scatter


p1 <- ggplot(genre_dna, aes(x = avg_valence, y = avg_energy)) +
  geom_point(aes(size = avg_popularity, color = avg_danceability), alpha = 0.7) +
  geom_text_repel(data = genre_dna %>% 
                    filter(track_genre %in% featured_genres),
                  aes(label = track_genre), size = 3, max.overlaps = 15) +
  scale_color_viridis(option = "plasma", name = "Danceability") +
  scale_size_continuous(name = "Popularity", range = c(2, 8)) +
  geom_hline(yintercept = 0.5, linetype = "dashed", alpha = 0.5) +
  geom_vline(xintercept = 0.5, linetype = "dashed", alpha = 0.5) +
  annotate("text", x = 0.25, y = 0.9, label = "Angry/Turbulent", fontface = "italic", alpha = 0.6) +
  annotate("text", x = 0.75, y = 0.9, label = "Happy/Energetic", fontface = "italic", alpha = 0.6) +
  annotate("text", x = 0.25, y = 0.1, label = "Sad/Quiet", fontface = "italic", alpha = 0.6) +
  annotate("text", x = 0.75, y = 0.1, label = "Peaceful/Positive", fontface = "italic", alpha = 0.6) +
  labs(title = "The Mood Map of Music Genres",
       subtitle = "Where does each genre live emotionally?",
       x = "Valence (Positivity)", y = "Energy") +
  theme(legend.position = "right")

ggsave("output/figures/genre_mood_map.png", p1, width = 12, height = 9, dpi = 300)


# 2. GENRE DNA RADAR/BAR COMPARISON


genre_dna_long <- genre_dna_featured %>%
  select(track_genre, avg_danceability, avg_energy, avg_valence, 
         avg_acousticness, avg_speechiness, avg_instrumentalness) %>%
  pivot_longer(-track_genre, names_to = "feature", values_to = "value") %>%
  mutate(feature = str_remove(feature, "avg_"))

p2 <- ggplot(genre_dna_long, aes(x = feature, y = value, fill = track_genre)) +
  geom_bar(stat = "identity", position = position_dodge(width = 0.8), width = 0.7) +
  scale_fill_viridis_d(option = "turbo") +
  labs(title = "Genre DNA: Audio Feature Fingerprints",
       subtitle = "Comparing the sonic signatures of 10 popular genres",
       x = "", y = "Average Value (0-1 scale)", fill = "Genre") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1),
        legend.position = "bottom") +
  guides(fill = guide_legend(nrow = 2))

ggsave("output/figures/genre_dna_comparison.png", p2, width = 14, height = 8, dpi = 300)


# 3. ENERGY RIDGELINE PLOT - Distribution by genre


p3 <- ggplot(spotify_featured, aes(x = energy, y = track_genre, fill = track_genre)) +
  geom_density_ridges(alpha = 0.8, scale = 2) +
  scale_fill_viridis_d(option = "plasma") +
  labs(title = "Energy Distribution Across Genres",
       subtitle = "How energetic are songs in each genre?",
       x = "Energy Level", y = "") +
  theme(legend.position = "none")

ggsave("output/figures/energy_ridgeline.png", p3, width = 10, height = 8, dpi = 300)


# 4. POPULARITY vs FEATURES - What makes a hit?


p4 <- spotify_clean %>%
  sample_n(5000) %>%  # Sample for clearer visualization
  ggplot(aes(x = danceability, y = popularity, color = energy)) +
  geom_point(alpha = 0.4, size = 1.5) +
  geom_smooth(method = "lm", color = "red", se = TRUE) +
  scale_color_viridis(option = "inferno") +
  labs(title = "The Hit Formula: Danceability vs Popularity",
       subtitle = "Do more danceable songs become more popular?",
       x = "Danceability", y = "Popularity Score", color = "Energy") +
  theme(legend.position = "right")

ggsave("output/figures/popularity_danceability.png", p4, width = 10, height = 7, dpi = 300)


# 5. ACOUSTIC vs ELECTRONIC SPECTRUM


p5 <- genre_dna %>%
  mutate(spectrum = avg_acousticness - (1 - avg_acousticness)) %>%
  slice_max(abs(spectrum), n = 20) %>%
  mutate(track_genre = fct_reorder(track_genre, spectrum)) %>%
  ggplot(aes(x = spectrum, y = track_genre, fill = spectrum)) +
  geom_col() +
  scale_fill_gradient2(low = "#00CED1", mid = "gray90", high = "#8B4513",
                       midpoint = 0, name = "Spectrum") +
  geom_vline(xintercept = 0, linetype = "dashed") +
  labs(title = "The Acoustic-Electronic Spectrum",
       subtitle = "Which genres lean organic vs synthetic?",
       x = "← Electronic | Acoustic →", y = "") +
  theme(legend.position = "none")

ggsave("output/figures/acoustic_electronic_spectrum.png", p5, width = 10, height = 8, dpi = 300)


# 6. MOOD QUADRANT PIE/DONUT BY GENRE

mood_summary <- spotify_featured %>%
  count(track_genre, mood_quadrant) %>%
  group_by(track_genre) %>%
  mutate(pct = n / sum(n))

p6 <- ggplot(mood_summary, aes(x = track_genre, y = pct, fill = mood_quadrant)) +
  geom_bar(stat = "identity", position = "fill") +
  scale_fill_manual(values = c("Happy & Energetic" = "#FFD700",
                               "Peaceful & Positive" = "#98FB98",
                               "Angry & Turbulent" = "#FF6347",
                               "Sad & Quiet" = "#6495ED")) +
  coord_flip() +
  labs(title = "Emotional Composition of Genres",
       subtitle = "What moods dominate each genre?",
       x = "", y = "Proportion", fill = "Mood") +
  theme(legend.position = "bottom")

ggsave("output/figures/mood_composition.png", p6, width = 10, height = 7, dpi = 300)


dashboard <- (p1 | p5) / (p3 | p6) +
  plot_annotation(
    title = "🎵 The DNA of Music: A Visual Exploration",
    subtitle = "Analyzing 114,000 tracks across 125 genres",
    theme = theme(plot.title = element_text(size = 18, face = "bold"),
                  plot.subtitle = element_text(size = 12))
  )

ggsave("output/figures/dashboard_combined.png", dashboard, width = 18, height = 14, dpi = 300)

print("Done!")
