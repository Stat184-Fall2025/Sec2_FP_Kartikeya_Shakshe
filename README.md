# FP_Kartikeya_Shakshe_Music_evolution_project

The Evolution of Popular Music (1960s–2020s)
--This project analyzes how popular music has changed from the 1960s to the 2020s using audio features from the Spotify Web API. It focuses on characteristics such as tempo, energy, danceability, valence (musical "happiness"), speechiness, and acousticness to quantify how songs differ across decades.

--The code downloads track data from decade‑based playlists, extracts audio features, cleans and aggregates the data, and then performs exploratory and statistical analysis. The project produces static plots, animated visualizations, and summary tables that highlight trends in song speed, mood, and style over time.

Features
--Automated data collection from Spotify by decade (1960s–2020s) using an R wrapper around the Spotify Web API.

--Data preprocessing pipelines that create a clean dataset and decade‑level summaries.

--Exploratory analysis of distributions and correlations between key audio features.

--Statistical tests (e.g., ANOVA and pairwise comparisons) to assess whether musical features differ significantly across decades.

--Static and animated visualizations showing how tempo, energy, danceability, and mood have evolved.

Tech Stack
--Language: R

--Key packages: spotifyr, tidyverse, ggplot2, gganimate, viridis, corrplot, patchwork

