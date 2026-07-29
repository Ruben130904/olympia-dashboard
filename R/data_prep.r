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



# --- Value-Box-Kennzahlen ---

# Anzahl Teilnehmer*innen alltime (eindeutige Athlet*innen über alle Spiele)
n_total <- athlete_events |> 
  distinct(ID) |> 
  nrow()

# Neuestes Jahr im Datensatz
latest_year <- max(athlete_events$Year)

# Geschlechterverteilung im neuesten Jahr (eindeutige Athlet*innen)

current_gender <- athlete_events |> 
  filter(Year == latest_year) |> 
  distinct(ID, Sex) |> 
  count(Sex, name = "n") |> 
  mutate(share = n / sum(n))

n_women_current     <- current_gender %>% filter(Sex == "F") %>% pull(n)
share_women_current <- current_gender %>% filter(Sex == "F") %>% pull(share)

# Erstes Jahr, in dem Frauen teilgenommen haben
first_year_women <- athlete_events |> 
  filter(Sex == "F") |> 
  pull(Year) |> 
  min()

# Geschlechterverteilung in diesem ersten Jahr
first_year_gender <- athlete_events |> 
  filter(Year == first_year_women) |> 
  distinct(ID, Sex) |> 
  count(Sex, name = "n") |> 
  mutate(share = n / sum(n))

n_women_first     <- first_year_gender %>% filter(Sex == "F") %>% pull(n)
share_women_first <- first_year_gender %>% filter(Sex == "F") %>% pull(share)
