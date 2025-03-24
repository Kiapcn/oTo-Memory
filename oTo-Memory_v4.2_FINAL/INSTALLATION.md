# Installation de oTo-Memory

## Méthode simple (recommandée)
1. Double-cliquez sur `oTo-Memory_v4.2.dmg`
2. Glissez `oTo-Memory.app` dans le dossier Applications
3. Lancez l'application depuis le Launchpad

## Méthode avancée (via terminal)
```bash
# Monter le DMG
hdiutil attach oTo-Memory_v4.2.dmg

# Copier l'application
cp -r /Volumes/oTo-Memory/oTo-Memory.app /Applications/

# Démontrer le DMG
hdiutil detach /Volumes/oTo-Memory

# Lancer l'application
open /Applications/oTo-Memory.app
```

## Désinstallation
1. Quittez l'application
2. Supprimez `oTo-Memory.app` du dossier Applications
3. (Optionnel) Supprimez les données utilisateur :
   ```bash
   rm -rf ~/Library/Application\ Support/oTo-Memory/
   ```

## Support
Pour toute question ou problème, consultez la documentation dans le dossier `docs/`.
