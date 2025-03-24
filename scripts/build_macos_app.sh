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
BUILD_DIR="build/ready_to_export"

# Nettoyer les anciens builds
log "Nettoyage des anciens builds..."
rm -rf "$BUILD_DIR"

# Vérifier Flutter
if ! command -v flutter &> /dev/null; then
    error "Flutter n'est pas installé. Veuillez l'installer via https://flutter.dev"
    exit 1
fi

# Compiler l'application Flutter
log "Compilation de l'application Flutter..."
cd frontend/flutter_app
flutter clean
flutter pub get
flutter build macos --release
cd ../..

# Créer la structure du .app
log "Création de la structure du .app..."
mkdir -p "$BUILD_DIR/${APP_NAME}.app/Contents/MacOS"
mkdir -p "$BUILD_DIR/${APP_NAME}.app/Contents/Resources"

# Copier les fichiers Flutter
cp -r "frontend/flutter_app/build/macos/Build/Products/Release/flutter_app.app/Contents/MacOS/flutter_app" "$BUILD_DIR/${APP_NAME}.app/Contents/MacOS/"
cp -r "frontend/flutter_app/build/macos/Build/Products/Release/flutter_app.app/Contents/Resources"/* "$BUILD_DIR/${APP_NAME}.app/Contents/Resources/"

# Créer le script de lancement
cat > "$BUILD_DIR/${APP_NAME}.app/Contents/MacOS/start_oTo" << 'EOF'
#!/bin/bash

# Dossier de support
SUPPORT_DIR="$HOME/Library/Application Support/oTo-Memory"
mkdir -p "$SUPPORT_DIR/logs"

# Démarrer le backend
cd "$(dirname "$0")/../../../../backend"
python3 main.py > "$SUPPORT_DIR/logs/backend.log" 2>&1 &
BACKEND_PID=$!

# Attendre que le backend soit prêt
sleep 2

# Démarrer l'interface Flutter
cd "$(dirname "$0")/../../../../frontend/flutter_app"
flutter run -d macos > "$SUPPORT_DIR/logs/flutter.log" 2>&1 &
FLUTTER_PID=$!

# Sauvegarder les PIDs
echo $BACKEND_PID > "$SUPPORT_DIR/logs/backend.pid"
echo $FLUTTER_PID > "$SUPPORT_DIR/logs/flutter.pid"
EOF

chmod +x "$BUILD_DIR/${APP_NAME}.app/Contents/MacOS/start_oTo"

# Créer Info.plist
cat > "$BUILD_DIR/${APP_NAME}.app/Contents/Info.plist" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleDevelopmentRegion</key>
    <string>fr</string>
    <key>CFBundleExecutable</key>
    <string>start_oTo</string>
    <key>CFBundleGetInfoString</key>
    <string>oTo-Memory v${VERSION}</string>
    <key>CFBundleIconFile</key>
    <string>AppIcon</string>
    <key>CFBundleIdentifier</key>
    <string>com.otomemory.app</string>
    <key>CFBundleInfoDictionaryVersion</key>
    <string>6.0</string>
    <key>CFBundleName</key>
    <string>${APP_NAME}</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>CFBundleShortVersionString</key>
    <string>${VERSION}</string>
    <key>LSMinimumSystemVersion</key>
    <string>10.15</string>
    <key>LSUIElement</key>
    <true/>
    <key>NSHighResolutionCapable</key>
    <true/>
    <key>NSHumanReadableCopyright</key>
    <string>Copyright © 2024 oTo-Memory. All rights reserved.</string>
</dict>
</plist>
EOF

# Copier les ressources backend
mkdir -p "$BUILD_DIR/${APP_NAME}.app/Contents/Resources/backend"
cp -r backend/* "$BUILD_DIR/${APP_NAME}.app/Contents/Resources/backend/"

# Créer le dossier mobile_ready
mkdir -p mobile_ready
cat > mobile_ready/README_mobile.md << 'EOF'
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
EOF

log "Application compilée avec succès"
log "Le .app est disponible dans : $BUILD_DIR/${APP_NAME}.app" 