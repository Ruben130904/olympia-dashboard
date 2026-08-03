## Hier werden die Tabellen erstellt, welche ich in der qmd zur Visualisierung brauche

# Libs
library(tidyverse)
library(countrycode)


# Data 
athlete_events <- read_csv("Data/Raw/athlete_events.csv")
regions <- read_csv("Data/Raw/noc_regions.csv") # Nutzung ab Seite 3

# Daten vorbereiten
athlete_events <- athlete_events |> 
  mutate(Season = recode(Season, "Summer" = "Sommer", "Winter" = "Winter"))

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

stats_summer <- get_valuebox_stats("Sommer")
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

# Sportarten identifizieren, die durchgehend nur ein Geschlecht haben
single_sex_sports <- gender_by_sport |> 
  group_by(Sport) |> 
  summarise(min_share = min(share), max_share = max(share)) |> 
  filter(min_share == max_share & min_share %in% c(0, 1)) |> 
  pull(Sport)

# Für den Zeitreihen-Chart: nur Sportarten mit tatsächlicher Entwicklung
gender_by_sport_mixed <- gender_by_sport |> 
  filter(!Sport %in% single_sex_sports)




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
    (Season == "Sommer" & Year == 2016) |
    (Season == "Winter" & Year == 2014)
  ) |> 
  distinct(Sport) |> 
  pull(Sport)

# Bestehende Tabelle darauf einschränken
gender_by_sport_current <- gender_by_sport_current |> 
  filter(Sport %in% current_sports)


# Gender nach Land

get_gender_by_country <- function(season, year) {
  athlete_events |> 
    filter(Year == year, Season == season) |> 
    distinct(ID, NOC, Sex) |> 
    count(NOC, Sex, name = "n") |> 
    group_by(NOC) |> 
    mutate(total = sum(n), share = n / total) |> 
    ungroup() |> 
    filter(Sex == "F") |> 
    mutate(iso3 = countrycode(
      NOC,
      origin = "ioc",
      destination = "iso3c",
      custom_match = c("KOS" = "XKX", "LIB" = "LBN")
    ))
}

gender_by_country_summer <- get_gender_by_country("Sommer", 2016)
gender_by_country_winter <- get_gender_by_country("Winter", 2014)


