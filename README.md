# Plome
## _Pour les étudiants !_

Plôme est une application qui permet de simuler l'obtention (ou non) de son diplôme.

## Features

- Simulations d'examens
- Création de modèles d'examens personnalisés
- Détails des résultats de l'examen
- Partage de modèles avec d'autres utilisateurs

## Tech

Librairies utilisées:

- Firebase analytics 
- Firebase crashlytics
- IQKeyboardManager (https://github.com/hackiftekhar/IQKeyboardManager)
- Material Component (https://github.com/material-components/material-components-ios)
- UIOnboarding (https://github.com/lascic/UIOnboarding)
- NotificationBanner (https://github.com/Daltron/NotificationBanner)
- Tabman (https://github.com/uias/Tabman)
- Factory (https://github.com/hmlongco/Factory)

Service utilisé:

- FileIO pour l'hébergement des modèles de simulation partager (https://www.file.io/developers/)

## Dev

Pour générer les strings de PlomeCoreKit
```sh
swiftgen config run --config plomecorekit-config.yml
```

Pour générer les strings de Plome
```sh
swiftgen config run --config plome-config.yml
```

Pour générer les assets de Plome
```sh
swiftgen config run --config plome-assets.yml
```
