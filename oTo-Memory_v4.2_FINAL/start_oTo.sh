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

# Vérifier si Ollama est installé
if ! command -v ollama &> /dev/null; then
    error "Ollama n'est pas installé. Veuillez l'installer via https://ollama.ai"
    exit 1
fi

# Vérifier si le modèle phi est installé
if ! ollama list | grep -q "phi"; then
    log "Installation du modèle phi..."
    ollama pull phi
fi

# Créer le dossier de logs s'il n'existe pas
mkdir -p "$HOME/Library/Application Support/oTo-Memory/logs"

# Démarrer le backend en arrière-plan
log "Démarrage du backend..."
cd "$(dirname "$0")/backend"
python3 main.py > "$HOME/Library/Application Support/oTo-Memory/logs/backend.log" 2>&1 &
BACKEND_PID=$!

# Attendre que le backend soit prêt
sleep 2

# Démarrer l'interface Flutter
log "Démarrage de l'interface..."
cd "$(dirname "$0")/frontend/flutter_app"
flutter run -d macos > "$HOME/Library/Application Support/oTo-Memory/logs/flutter.log" 2>&1 &
FLUTTER_PID=$!

# Sauvegarder les PIDs pour le script d'arrêt
echo $BACKEND_PID > "$HOME/Library/Application Support/oTo-Memory/logs/backend.pid"
echo $FLUTTER_PID > "$HOME/Library/Application Support/oTo-Memory/logs/flutter.pid"

log "oTo-Memory v4.1 est en cours d'exécution"
log "Les logs sont disponibles dans ~/Library/Application Support/oTo-Memory/logs/"
