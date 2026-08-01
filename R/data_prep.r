## Hier werden die Tabellen erstellt, welche ich in der qmd zur Visualisierung brauche

# Libs
library(tidyverse)

# Data 
athlete_events <- read_csv("Data/Raw/athlete_events.csv")
regions <- read_csv("Data/Raw/noc_regions.csv") # Nutzung ab Seite 3

# Hilfsfunktionen
fmt_n   <- function(x) scales::comma(x)
fmt_pct <- function(x) scales::percent(x, accuracy = 0.1)

# Daten verarbeiten

gender_by_year <- athlete_events |> 
  distinct(ID, Year, Season, Sex) |> 
  count(Year, Season, Sex, name = "n") |> 
  group_by(Year, Season) |> 
  mutate(
    total = sum(n),
    share = n / total
  ) |> 
  ungroup()

gender_by_year_female <- gender_by_year |> 
  filter(Sex == "F") |> 
  select(Year, Season, share)

# --- Value-Box-Kennzahlen, pro Season ---

get_valuebox_stats <- function(season) {

  data_season <- athlete_events |> 
    filter(Season == season)

  # Teilnehmer*innen alltime (eindeutige Athlet*innen in dieser Season)
  n_total <- data_season |> 
    distinct(ID) |> 
    nrow()

  # Neuestes Jahr in dieser Season
  latest_year <- max(data_season$Year)

  current_gender <- data_season |> 
    filter(Year == latest_year) |> 
    distinct(ID, Sex) |> 
    count(Sex, name = "n") |> 
    mutate(share = n / sum(n))

  n_women_current     <- current_gender |> filter(Sex == "F") |> pull(n)
  share_women_current <- current_gender |> filter(Sex == "F") |> pull(share)

  # Erstes Jahr mit Frauen in dieser Season
  first_year_women <- data_season |> 
    filter(Sex == "F") |> 
    pull(Year) |> 
    min()

  first_year_gender <- data_season |> 
    filter(Year == first_year_women) |> 
    distinct(ID, Sex) |> 
    count(Sex, name = "n") |> 
    mutate(share = n / sum(n))

  n_women_first     <- first_year_gender |> filter(Sex == "F") |> pull(n)
  share_women_first <- first_year_gender |> filter(Sex == "F") |> pull(share)

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


# Layouts
## Farbpalette festlegen

col_summer <- "#E69F00"
col_winter <- "#0072B2"


# Data prep für Seite 2
# Genderanteil nach Sportart

# In R/data_prep.R ergänzen

gender_by_sport <- athlete_events |> 
  distinct(ID, Year, Sport, Sex) |> 
  count(Year, Sport, Sex, name = "n") |> 
  group_by(Year, Sport) |> 
  mutate(total = sum(n), share = n / total) |> 
  ungroup() |> 
  filter(Sex == "F")




gender_by_sport_current <- athlete_events |> 
  distinct(ID, Year, Season, Sport, Sex) |> 
  count(Year, Season, Sport, Sex, name = "n") |> 
  group_by(Year, Season, Sport) |> 
  mutate(total = sum(n), share = n / total) |> 
  ungroup() |> 
  filter(Sex == "F") |> 
  group_by(Sport) |> 
  filter(Year == max(Year)) |>   # nur das neueste Jahr je Sportart
  ungroup()

# Sportarten, die aktuell noch olympisch sind
current_sports <- athlete_events |> 
  filter(
    (Season == "Summer" & Year == 2016) |
    (Season == "Winter" & Year == 2014)
  ) |> 
  distinct(Sport) |> 
  pull(Sport)

# Bestehende Tabelle darauf einschränken
gender_by_sport_current <- gender_by_sport_current |> 
  filter(Sport %in% current_sports)
