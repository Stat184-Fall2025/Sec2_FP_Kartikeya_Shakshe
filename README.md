# FP_Kartikeya_Shakshe_Music_evolution_project

The DNA of Music: Decoding Genre Personalities Through Sound
An exploratory data analysis project that uncovers the unique "audio fingerprint" of 125 music genres by analyzing 114,000 Spotify tracks. This project transforms raw audio features into visual insights about why different genres make us feel and move differently.

[![Dataset](https://img.shields.io/badge/Dataset-Kaggle-20BEFF.svg)](https://www.kaggle.com/datasets/maharshipandya/-spotify-tracks-dataset)

Table of Contents

- [Overview](#overview)
- [Research Questions](#research-questions)
- [Dataset](#dataset)
- [Features](#features)
- [Installation](#installation)
- [Usage](#usage)
- [Project Structure](#project-structure)
- [Visualizations](#visualizations)
- [Key Findings](#key-findings)
- [Contributing](#contributing)
- [License](#license)

Overview

Every music genre has a distinct sonic personality. Jazz feels different from metal. Pop sounds different from classical. But *why*? This project quantifies those differences using Spotify's audio analysis features to:

- Map genres on an emotional spectrum (happy/sad × calm/energetic)
- Create unique "DNA profiles" for each genre
- Identify what audio characteristics predict popularity
- Reveal hidden relationships between seemingly different genres

Research Questions

1. What makes each genre sonically unique?
2. Where do genres live on the emotional spectrum?
3. What audio characteristics predict a song's popularity?
4. How do genres cluster based on their sonic DNA?

Dataset

This project uses the [Spotify Tracks Dataset](https://www.kaggle.com/datasets/maharshipandya/-spotify-tracks-dataset) from Kaggle, containing:

- 114,000+ tracks
- 125 genres
- 20+ audio features per track

 Audio Features Analyzed

 Feature  Description  Scale 
 Danceability  How suitable for dancing based on tempo, rhythm stability, beat strength  0–1 
 Energy  Perceptual measure of intensity and activity  0–1 
 Valence  Musical positivity (happy, cheerful vs. sad, angry)  0–1 
 Tempo  Estimated beats per minute  BPM 
 Acousticness  Confidence that the track is acoustic  0–1 
 Speechiness  Presence of spoken words  0–1 
 Instrumentalness  Predicts whether a track contains no vocals  0–1 
 Loudness  Overall loudness in decibels  dB 
 Liveness  Presence of an audience in the recording  0–1 

Features

- Genre Mood Mapping: 2D visualization plotting genres on valence-energy axes
- Audio DNA Profiling: Comparative fingerprints across multiple audio dimensions
- Statistical Analysis: ANOVA, Tukey HSD, and regression modeling
- Popularity Prediction: Linear regression identifying hit-making characteristics
- Animated Visualizations: Dynamic GIFs showing genre transitions and distributions
- Interactive Dashboard: Combined multi-panel visualization



