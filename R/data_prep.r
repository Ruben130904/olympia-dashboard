## Hier werden die Tabellen erstellt, welche ich in der qmd zur Visualisierung brauche

# Libs
library(tidyverse)

# Data 
athlete_events <- read_csv("Data/Raw/athlete_events.csv")
regions <- read_csv("Data/Raw/noc_regions.csv")

# Daten verabreiten

gender_by_year <- athlete_events %>%
  distinct(ID, Year, Season, Sex) %>%      # eine Zeile pro Person und Olympiade
  count(Year, Season, Sex, name = "n") %>%  # Anzahl je Jahr/Saison/Geschlecht
  group_by(Year, Season) %>%
  mutate(
    total = sum(n),
    share = n / total                       # Anteil je Geschlecht
  ) %>%
  ungroup()

gender_by_year_female <- gender_by_year %>%
  filter(Sex == "F") %>%
  select(Year, Season, share)
