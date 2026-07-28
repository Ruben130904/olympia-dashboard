# Erstes Daten einladen und anschauen
# Nur zur eigenen Übersicht, nicht zur Abgabe nötig

# Libs
library("tidyverse")

# Daten einlesen

athlete_events <- read_csv("Data/Raw/athlete_events.csv")
regions <- read_csv("Data/Raw/noc_regions.csv")

# Daten anschauen

glimpse(athlete_events)
head(athlete_events)

dim(athlete_events)      # Zeilen x Spalten
nrow(athlete_events)
ncol(athlete_events)

colSums(is.na(athlete_events))

sum(is.na(athlete_events$Medal))


distinct(athlete_events, Sex)
distinct(athlete_events, Season)
n_distinct(athlete_events$Sport)     # wie viele unterschiedliche Sportarten
count(athlete_events, Sport)           # Häufigkeiten

athlete_events |> 
  count(Year, Sex)
