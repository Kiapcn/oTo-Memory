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

# Dossier de support
SUPPORT_DIR="$HOME/Library/Application Support/oTo-Memory"

# Sauvegarder le dernier sujet avant de fermer
if [ -f "$SUPPORT_DIR/user_memory/last_topic.txt" ]; then
    cp "$SUPPORT_DIR/user_memory/last_topic.txt" "$SUPPORT_DIR/user_memory/last_topic.txt.bak"
fi

# Logger l'arrêt
log "Arrêt de oTo-Memory v4.1..."

# Arrêter le backend
if [ -f "$SUPPORT_DIR/logs/backend.pid" ]; then
    BACKEND_PID=$(cat "$SUPPORT_DIR/logs/backend.pid")
    if kill -0 $BACKEND_PID 2>/dev/null; then
        log "Arrêt du backend..."
        kill $BACKEND_PID
        sleep 1
        if kill -0 $BACKEND_PID 2>/dev/null; then
            warn "Le backend ne répond pas, arrêt forcé..."
            kill -9 $BACKEND_PID
        fi
        rm "$SUPPORT_DIR/logs/backend.pid"
    fi
fi

# Arrêter l'interface Flutter
if [ -f "$SUPPORT_DIR/logs/flutter.pid" ]; then
    FLUTTER_PID=$(cat "$SUPPORT_DIR/logs/flutter.pid")
    if kill -0 $FLUTTER_PID 2>/dev/null; then
        log "Arrêt de l'interface..."
        kill $FLUTTER_PID
        sleep 1
        if kill -0 $FLUTTER_PID 2>/dev/null; then
            warn "L'interface ne répond pas, arrêt forcé..."
            kill -9 $FLUTTER_PID
        fi
        rm "$SUPPORT_DIR/logs/flutter.pid"
    fi
fi

# Arrêter Ollama si nécessaire
if pgrep -f "ollama run phi" > /dev/null; then
    log "Arrêt d'Ollama..."
    pkill -f "ollama run phi"
    sleep 1
fi

# Nettoyer les processus restants
pkill -f "uvicorn main:app"
pkill -f "flutter run"

log "oTo-Memory v4.1 a été arrêté avec succès" 