# oTo-Memory

Une IA personnelle locale avec mémoire évolutive, fonctionnant via FastAPI + Ollama (phi) + Flutter.

## Fonctionnalités

- 🤖 IA locale avec le modèle phi d'Ollama
- 💾 Mémoire évolutive et sauvegarde automatique
- 🎯 Interface utilisateur native macOS
- 🔒 Données stockées localement et sécurisées
- 🔄 Mise à jour automatique
- 📱 Application native macOS (.app)

## Prérequis

- macOS 10.15 ou supérieur
- Python 3.8+
- Flutter 3.0+
- Ollama (installé automatiquement)

## Installation

1. Téléchargez la dernière version depuis [GitHub Releases](https://github.com/Kiapcn/oTo-Memory/releases)
2. Double-cliquez sur `oTo-Memory_v4.1.dmg`
3. Glissez `oTo-Memory.app` dans le dossier Applications
4. Lancez l'application depuis le Launchpad

## Utilisation

### Lancement
- Double-cliquez sur l'icône dans le Launchpad
- L'application se lance automatiquement
- Aucune fenêtre terminal n'apparaît

### Arrêt
- Cliquez sur le menu oTo-Memory > Quitter
- Ou utilisez Cmd+Q

### Mise à jour
1. Téléchargez la nouvelle version
2. Double-cliquez sur le DMG
3. Remplacez l'ancienne version dans Applications
4. Vos données sont préservées

## Structure du projet

```
oTo-Memory/
├── backend/           # Serveur FastAPI
├── frontend/         # Application Flutter
│   └── flutter_app/  # Code source Flutter
├── scripts/          # Scripts utilitaires
└── docs/            # Documentation
```

## Développement

### Configuration de l'environnement

```bash
# Installation des dépendances
./install_mac.sh

# Compilation
./build_macos_app.sh

# Lancement en mode développement
./start_oTo.sh
```

### Scripts disponibles

- `start_oTo.sh` : Lance l'application
- `stop_oTo.sh` : Arrête l'application
- `memory_status.sh` : Affiche l'état de la mémoire
- `update_oTo.sh` : Met à jour l'application
- `prepare_distribution.sh` : Prépare le DMG

## Contribution

1. Fork le projet
2. Créez une branche (`git checkout -b feature/AmazingFeature`)
3. Committez vos changements (`git commit -m 'Add some AmazingFeature'`)
4. Push vers la branche (`git push origin feature/AmazingFeature`)
5. Ouvrez une Pull Request

## Licence

Ce projet est sous licence MIT. Voir le fichier `LICENSE` pour plus de détails.

## Support

- Documentation : [Wiki](https://github.com/Kiapcn/oTo-Memory/wiki)
- Issues : [GitHub Issues](https://github.com/Kiapcn/oTo-Memory/issues)
- Discussions : [GitHub Discussions](https://github.com/Kiapcn/oTo-Memory/discussions)

