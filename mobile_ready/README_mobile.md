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

## Notes de développement

### Sécurité mobile
1. Toutes les données sont stockées localement
2. Chiffrement des données sensibles
3. Authentification biométrique optionnelle
4. Pas de connexion réseau requise

### Base de données
- Utilisation de SQLite avec chiffrement
- Migration automatique des données
- Backup local avec compression
- Pas de synchronisation cloud

### Interface utilisateur
- Design adaptatif
- Support du mode sombre
- Gestes tactiles
- Notifications locales

## Roadmap

### Version 1.0
- [ ] Interface utilisateur de base
- [ ] Stockage local sécurisé
- [ ] Synchronisation avec la version desktop
- [ ] Support offline complet

### Version 2.0
- [ ] Widgets pour le bureau
- [ ] Partage de données entre appareils
- [ ] Mode conversation continue
- [ ] Personnalisation avancée

## Contribution
1. Fork le projet
2. Créez une branche (`git checkout -b feature/AmazingFeature`)
3. Committez vos changements (`git commit -m 'Add some AmazingFeature'`)
4. Push vers la branche (`git push origin feature/AmazingFeature`)
5. Ouvrez une Pull Request 