#!/bin/bash
echo "📦 Préparation de la distribution oTo-Memory v4.0..."

# Création du dossier de distribution
DIST_DIR="build/ready_to_export"
rm -rf "$DIST_DIR"
mkdir -p "$DIST_DIR"

# Compilation de l'application
echo "🏗️  Compilation de l'application..."
./build_macos_app.sh

# Création du DMG
echo "📦 Création du DMG..."
DMG_NAME="oTo-Memory_v4.0.dmg"
DMG_TEMP="oTo-Memory_temp.dmg"
DMG_FINAL="$DIST_DIR/$DMG_NAME"

# Création du DMG temporaire
hdiutil create -size 500m -fs HFS+ -volname "oTo-Memory" "$DMG_TEMP"

# Montage du DMG
hdiutil attach "$DMG_TEMP"

# Copie de l'application
cp -r "$DIST_DIR/oTo-Memory.app" "/Volumes/oTo-Memory/"

# Création du lien vers Applications
ln -s /Applications "/Volumes/oTo-Memory/Applications"

# Démonter le DMG
hdiutil detach "/Volumes/oTo-Memory"

# Convertir en DMG compressé
hdiutil convert "$DMG_TEMP" -format UDZO -o "$DMG_FINAL"

# Nettoyage
rm "$DMG_TEMP"

# Création du fichier de version
echo "4.0.0" > "$DIST_DIR/VERSION"

# Création du fichier de changelog
cat > "$DIST_DIR/CHANGELOG.md" << EOF
# Changelog oTo-Memory v4.0

## Nouveautés
- Application native macOS (.app)
- Gestion des données utilisateur dans ~/Library/Application Support/
- Système de sauvegarde automatique
- Mise à jour automatique
- Interface utilisateur améliorée

## Améliorations
- Meilleure gestion de la mémoire
- Sauvegarde des conversations par date
- Reprise des discussions précédentes
- Logs de diagnostic

## Corrections
- Support macOS natif
- Gestion des erreurs améliorée
- Performance optimisée

## Notes
- Les données utilisateur sont maintenant stockées dans ~/Library/Application Support/oTo-Memory/
- Les mises à jour préservent les données utilisateur
- Support du modèle phi d'Ollama
EOF

echo "✅ Distribution préparée !"
echo "📦 DMG créé : $DMG_FINAL"
echo "ℹ️  Pour installer :"
echo "1. Double-cliquer sur $DMG_NAME"
echo "2. Glisser oTo-Memory.app dans le dossier Applications"
echo "3. Lancer l'application depuis le Launchpad ou Applications" 