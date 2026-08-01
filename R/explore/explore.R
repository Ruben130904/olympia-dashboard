# Erstes Daten einladen und anschauen
# Nur zur eigenen Übersicht, nicht zur Abgabe nötig

# Libs
library("tidyverse")
library(plotly)

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




p2 <- ggplot(gender_by_sport, aes(x = Year, y = share, group = Sport, text = Sport, color = Sport)) +
  geom_line(alpha = 0.3, linewidth = 0.5) +
  scale_y_continuous(labels = scales::percent, limits = c(0, 1)) +
  labs(
    x = "Jahr",
    y = "Frauenanteil",
    title = NULL
  ) +
  theme_minimal(base_size = 13)

ggplotly(p2, tooltip = "text")

p2

Sync <- gender_by_sport |> 
  filter(Sport == "Synchronized Swimming")
Sync
