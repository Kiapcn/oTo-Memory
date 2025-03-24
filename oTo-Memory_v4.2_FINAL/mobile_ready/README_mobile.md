# oTo-Memory Mobile

## Préparation pour iOS/Android

### Structure
- `lib/` : Code source Flutter
- `android/` : Configuration Android
- `ios/` : Configuration iOS
- `mobile_secure/` : Sécurité mobile

### Sécurité
- Chiffrement local avec Hive
- Sandbox des données
- Authentification biométrique
- Sauvegarde locale

### Base de données
- SQLite avec chiffrement
- Migration automatique
- Backup local

## Build

### iOS
```bash
flutter build ios --release
```

### Android
```bash
flutter build apk --release
```
