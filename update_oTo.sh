#!/bin/bash
echo "🔄 Mise à jour de oTo-Memory..."

# Vérification de l'environnement
if ! command -v git &> /dev/null; then
    echo "❌ Git n'est pas installé"
    exit 1
fi

# Sauvegarde des données utilisateur
USER_DATA_DIR="$HOME/Library/Application Support/oTo-Memory"
if [ -d "$USER_DATA_DIR" ]; then
    echo "💾 Sauvegarde des données utilisateur..."
    BACKUP_DIR="$USER_DATA_DIR/backups"
    mkdir -p "$BACKUP_DIR"
    TIMESTAMP=$(date +%Y%m%d_%H%M%S)
    cp -r "$USER_DATA_DIR/user_memory" "$BACKUP_DIR/user_memory_$TIMESTAMP"
    cp -r "$USER_DATA_DIR/logs" "$BACKUP_DIR/logs_$TIMESTAMP"
fi

# Mise à jour via git si disponible
if [ -d ".git" ]; then
    echo "📥 Mise à jour via git..."
    git pull origin main
else
    echo "📥 Mise à jour via archive..."
    # Téléchargement de la dernière version
    curl -L -o oTo-Memory_latest.zip https://github.com/yourusername/oTo-Memory/releases/latest/download/oTo-Memory_v4.0.zip
    unzip -o oTo-Memory_latest.zip
    rm oTo-Memory_latest.zip
fi

# Mise à jour des dépendances
echo "📦 Mise à jour des dépendances..."
cd backend
source venv/bin/activate
pip install -r requirements.txt
cd ../frontend/flutter_app
flutter pub get
cd ../..

# Recompilation de l'application
echo "🏗️  Recompilation de l'application..."
./build_macos_app.sh

echo "✅ Mise à jour terminée !"
echo "ℹ️  Pour lancer la nouvelle version : ./start_oTo.sh" 