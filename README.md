# Olympia Dashboard

Quarto-Dashboard zur Visualisierung der Olympia-Teilnehmer:innen-Daten (`athlete_events.csv`, `noc_regions.csv`).

## Setup (Positron)

Das Projekt nutzt [renv](https://rstudio.github.io/renv/) zur Verwaltung der R-Paketversionen. Damit alle im Team exakt dieselben Paketversionen verwenden, muss nach dem Klonen/Entpacken einmalig ein Restore-Schritt ausgeführt werden.

### 1. Projektordner als Workspace öffnen

In Positron: **File → Open Folder…** und den Projektordner auswählen (den Ordner, der `.Rprofile`, `renv.lock` und `dashboard.qmd` direkt enthält).

⚠️ Wichtig: den **Ordner** öffnen, nicht nur einzelne Dateien per Doppelklick – nur so wird das Arbeitsverzeichnis korrekt gesetzt und `.Rprofile` beim Start automatisch geladen.

### 2. R-Interpreter auswählen

Positron fragt beim ersten Öffnen nach der zu verwendenden R-Version (oben rechts bzw. in der Statusleiste wählbar). Auswählen, damit eine R-Session startet.

### 3. Arbeitsverzeichnis prüfen

In der R-Konsole:

```r
getwd()
```

Das Ergebnis sollte der Projektordner sein. Nur dann wurde `renv` beim Start korrekt aktiviert.

### 4. Pakete installieren

In der R-Konsole:

```r
renv::restore()
```

Das installiert alle im `renv.lock` festgelegten Paketversionen in die projekteigene Bibliothek (`renv/library/...`). Dieser Schritt ist nach dem ersten Öffnen einmalig nötig und muss z. B. nach einem `git pull` mit geändertem `renv.lock` wiederholt werden.

### 5. Dashboard rendern

Entweder:

- über den **Render**-Button oben in der geöffneten `dashboard.qmd`, oder
- im Terminal-Pane:

```bash
quarto render dashboard.qmd
```

## Stolperfallen

- **Terminal vs. R-Konsole:** Wird `quarto render` im Terminal-Pane ausgeführt, startet das einen eigenen R-Prozess. Vorher mit `pwd` prüfen, ob das Terminal wirklich im Projektordner steht (ggf. mit `cd` dorthin wechseln).
- **renv-Hinweis übersehen:** Falls beim Start der R-Konsole eine Meldung zu fehlenden/abweichenden Paketen erscheint, immer mit `renv::restore()` reagieren, bevor gerendert wird.
- **Neue Pakete im Projekt:** Wer neue Pakete verwendet, sollte nach dem Einbauen `renv::snapshot()` ausführen und das aktualisierte `renv.lock` committen/mitschicken, damit alle im Team denselben Stand haben.

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
