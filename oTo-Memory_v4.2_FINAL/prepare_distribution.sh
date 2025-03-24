#!/bin/bash

# Couleurs pour les messages
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Fonction pour logger les messages
log() {
    echo -e "${GREEN}[$(date '+%Y-%m-%d %H:%M:%S')] $1${NC}"
}

error() {
    echo -e "${RED}[$(date '+%Y-%m-%d %H:%M:%S')] ERREUR: $1${NC}"
}

warn() {
    echo -e "${YELLOW}[$(date '+%Y-%m-%d %H:%M:%S')] ATTENTION: $1${NC}"
}

# Version
VERSION="4.2.0"
APP_NAME="oTo-Memory"
DMG_NAME="${APP_NAME}_v${VERSION}.dmg"
BUILD_DIR="build/ready_to_export"

# Nettoyer les anciens builds
log "Nettoyage des anciens builds..."
rm -rf "$BUILD_DIR" *.dmg

# Compiler l'application
log "Compilation de l'application..."
./build_macos_app.sh

# Créer le DMG
log "Création du DMG..."
DMG_TEMP="temp.dmg"
DMG_FINAL="$DMG_NAME"

# Créer un dossier temporaire pour le DMG
mkdir -p "$BUILD_DIR/dmg_temp"

# Copier l'application dans le dossier temporaire
cp -r "$BUILD_DIR/${APP_NAME}.app" "$BUILD_DIR/dmg_temp/"

# Créer un lien vers le dossier Applications
ln -s /Applications "$BUILD_DIR/dmg_temp/Applications"

# Créer le DMG temporaire
hdiutil create -volname "$APP_NAME" -srcfolder "$BUILD_DIR/dmg_temp" -ov -format UDRW "$DMG_TEMP"

# Monter le DMG
hdiutil attach "$DMG_TEMP"

# Obtenir le nom du volume monté
VOLUME_NAME=$(hdiutil info | grep "/Volumes/$APP_NAME" | awk '{print $3}')

# Ajuster la fenêtre du Finder
osascript <<EOF
tell application "Finder"
    tell disk "$APP_NAME"
        open
        set current view of container window to icon view
        set toolbar visible of container window to false
        set statusbar visible of container window to false
        set the bounds of container window to {400, 100, 900, 400}
        set theViewOptions to the icon view options of container window
        set arrangement of theViewOptions to not arranged
        set icon size of theViewOptions to 72
        make new alias file at container window to POSIX file "/Applications" with properties {name:"Applications"}
        set position of item "$APP_NAME.app" of container window to {100, 100}
        set position of item "Applications" of container window to {375, 100}
        update without registering applications
        delay 1
        close
    end tell
end tell
EOF

# Démontrer le DMG
hdiutil detach "$VOLUME_NAME"

# Convertir le DMG en format compressé
hdiutil convert "$DMG_TEMP" -format UDZO -o "$DMG_FINAL"

# Nettoyer
rm -rf "$DMG_TEMP" "$BUILD_DIR/dmg_temp"

# Créer le fichier de version
echo "$VERSION" > VERSION

# Créer le changelog
cat > CHANGELOG.md << EOF
# Changelog

## v${VERSION} (2024-03-21)

### Nouveautés
- Application native macOS (.app)
- Installation par glisser-déposer
- Lancement automatique sans terminal
- Stockage sécurisé des données dans ~/Library/Application Support/
- Système de mise à jour simplifié
- Interface utilisateur améliorée

### Améliorations
- Scripts silencieux en arrière-plan
- Gestion robuste des processus
- Sauvegarde automatique des données
- Meilleure gestion des erreurs

### Corrections
- Problèmes de lancement/arrêt
- Gestion de la mémoire
- Compatibilité macOS

### Notes
- Cette version nécessite macOS 10.15 ou supérieur
- Les données utilisateur sont stockées dans ~/Library/Application Support/oTo-Memory/
- Les mises à jour peuvent être effectuées via le script update_oTo.sh
EOF

# Créer le fichier d'installation
cat > INSTALLATION.md << 'EOF'
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
EOF

log "Distribution préparée avec succès"
log "Le DMG est disponible : $DMG_FINAL"
log "Pour installer :"
log "1. Double-cliquez sur $DMG_FINAL"
log "2. Glissez oTo-Memory.app dans le dossier Applications"
log "3. Lancez l'application depuis le Launchpad" 