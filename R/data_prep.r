## Hier werden die Tabellen erstellt, welche ich in der qmd zur Visualisierung brauche

# Libs
library(tidyverse)

# Data 
athlete_events <- read_csv("Data/Raw/athlete_events.csv")
regions <- read_csv("Data/Raw/noc_regions.csv")

# Daten verarbeiten

gender_by_year <- athlete_events %>%
  distinct(ID, Year, Season, Sex) %>%
  count(Year, Season, Sex, name = "n") %>%
  group_by(Year, Season) %>%
  mutate(
    total = sum(n),
    share = n / total
  ) %>%
  ungroup()

gender_by_year_female <- gender_by_year %>%
  filter(Sex == "F") %>%
  select(Year, Season, share)

# --- Value-Box-Kennzahlen, pro Season ---

get_valuebox_stats <- function(season) {

  data_season <- athlete_events %>%
    filter(Season == season)

  # Teilnehmer*innen alltime (eindeutige Athlet*innen in dieser Season)
  n_total <- data_season %>%
    distinct(ID) %>%
    nrow()

  # Neuestes Jahr in dieser Season
  latest_year <- max(data_season$Year)

  current_gender <- data_season %>%
    filter(Year == latest_year) %>%
    distinct(ID, Sex) %>%
    count(Sex, name = "n") %>%
    mutate(share = n / sum(n))

  n_women_current     <- current_gender %>% filter(Sex == "F") %>% pull(n)
  share_women_current <- current_gender %>% filter(Sex == "F") %>% pull(share)

  # Erstes Jahr mit Frauen in dieser Season
  first_year_women <- data_season %>%
    filter(Sex == "F") %>%
    pull(Year) %>%
    min()

  first_year_gender <- data_season %>%
    filter(Year == first_year_women) %>%
    distinct(ID, Sex) %>%
    count(Sex, name = "n") %>%
    mutate(share = n / sum(n))

  n_women_first     <- first_year_gender %>% filter(Sex == "F") %>% pull(n)
  share_women_first <- first_year_gender %>% filter(Sex == "F") %>% pull(share)

  list(
    n_total              = n_total,
    latest_year           = latest_year,
    n_women_current       = n_women_current,
    share_women_current   = share_women_current,
    first_year_women      = first_year_women,
    n_women_first         = n_women_first,
    share_women_first     = share_women_first
  )
}

stats_summer <- get_valuebox_stats("Summer")
stats_winter <- get_valuebox_stats("Winter")