#!/bin/bash
echo "🏗️  Compilation de oTo-Memory pour macOS..."

# Vérification de Flutter
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter n'est pas installé"
    exit 1
fi

# Création du dossier de build
BUILD_DIR="build/ready_to_export"
rm -rf "$BUILD_DIR"
mkdir -p "$BUILD_DIR"

# Compilation de l'application Flutter
echo "📱 Compilation de l'interface Flutter..."
cd frontend/flutter_app
flutter clean
flutter pub get
flutter build macos --release
cd ../..

# Création de la structure .app
echo "📦 Création de la structure .app..."
APP_DIR="$BUILD_DIR/oTo-Memory.app"
mkdir -p "$APP_DIR/Contents/MacOS"
mkdir -p "$APP_DIR/Contents/Resources"

# Copie des fichiers Flutter
cp -r frontend/flutter_app/build/macos/Build/Products/Release/oTo-Memory.app/Contents/MacOS/* "$APP_DIR/Contents/MacOS/"
cp -r frontend/flutter_app/build/macos/Build/Products/Release/oTo-Memory.app/Contents/Resources/* "$APP_DIR/Contents/Resources/"

# Création du Info.plist
cat > "$APP_DIR/Contents/Info.plist" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleDevelopmentRegion</key>
    <string>en</string>
    <key>CFBundleExecutable</key>
    <string>oTo-Memory</string>
    <key>CFBundleIdentifier</key>
    <string>com.otomemory.app</string>
    <key>CFBundleInfoDictionaryVersion</key>
    <string>6.0</string>
    <key>CFBundleName</key>
    <string>oTo-Memory</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>CFBundleShortVersionString</key>
    <string>4.0</string>
    <key>CFBundleVersion</key>
    <string>1</string>
    <key>LSMinimumSystemVersion</key>
    <string>10.15</string>
    <key>LSUIElement</key>
    <true/>
    <key>NSHighResolutionCapable</key>
    <true/>
    <key>NSHumanReadableCopyright</key>
    <string>Copyright © 2024</string>
</dict>
</plist>
EOF

# Copie des ressources Python et Ollama
echo "🐍 Copie des ressources backend..."
mkdir -p "$APP_DIR/Contents/Resources/backend"
cp -r backend/* "$APP_DIR/Contents/Resources/backend/"

# Création du script de lancement
cat > "$APP_DIR/Contents/MacOS/start_oTo" << EOF
#!/bin/bash
DIR="\$( cd "\$( dirname "\${BASH_SOURCE[0]}" )" && pwd )"
cd "\$DIR/../Resources/backend"
source venv/bin/activate
uvicorn main:app --reload --port 8000
EOF

chmod +x "$APP_DIR/Contents/MacOS/start_oTo"

# Création du script principal
cat > "$APP_DIR/Contents/MacOS/oTo-Memory" << EOF
#!/bin/bash
DIR="\$( cd "\$( dirname "\${BASH_SOURCE[0]}" )" && pwd )"
cd "\$DIR/../Resources"

# Création du dossier de données utilisateur
USER_DATA_DIR="\$HOME/Library/Application Support/oTo-Memory"
mkdir -p "\$USER_DATA_DIR"

# Lancement du backend
"\$DIR/start_oTo" &

# Lancement de l'interface Flutter
"\$DIR/oTo-Memory" --user-data-dir="\$USER_DATA_DIR"
EOF

chmod +x "$APP_DIR/Contents/MacOS/oTo-Memory"

echo "✅ Application compilée avec succès !"
echo "📦 Application disponible dans : $APP_DIR" 