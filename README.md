# Olympia Dashboard

Quarto-Dashboard zur Visualisierung der Olympia-Teilnehmer:innen-Daten (`athlete_events.csv`, `noc_regions.csv`).

## Setup
Das Projekt nutzt [renv](https://rstudio.github.io/renv/)

### Einmalig Pakete installieren

In der R-Konsole:

```r
renv::restore()
```

Das installiert alle im `renv.lock` festgelegten Paketversionen in die projekteigene Bibliothek (`renv/library/...`). Dieser Schritt ist nach dem ersten Öffnen einmalig nötig und muss z. B. nach einem `git pull` mit geändertem `renv.lock` wiederholt werden.


## Projektstruktur

```
.
├── dashboard.qmd          # Haupt-Dashboard (Quarto)
├── R/
│   ├── data_prep.r        # Datenaufbereitung für das Dashboard
│   └── explore.R          # Explorative Analyse (nicht zur Abgabe nötig)
├── Data/Raw/               # Rohdaten (CSV)
├── renv.lock               # exakte Paketversionen
├── renv/                   # renv-Infrastruktur (activate.R, settings.json)
└── .Rprofile                # sourced beim R-Start, aktiviert renv
```
