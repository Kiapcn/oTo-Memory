#!/bin/bash

# Couleurs pour les messages
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Fonctions de logging
log() {
    echo -e "${BLUE}📝 $1${NC}"
}

error() {
    echo -e "${RED}❌ $1${NC}"
}

success() {
    echo -e "${GREEN}✅ $1${NC}"
}

warn() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

echo "🚀 Installation de oTo-Memory v4.0..."

# Vérification de Python 3.11
if ! command -v python3.11 &> /dev/null; then
    error "Python 3.11 n'est pas installé. Installation en cours..."
    brew install python@3.11
fi

# Vérification de Flutter
if ! command -v flutter &> /dev/null; then
    echo "📱 Installation de Flutter..."
    brew install flutter
fi

# Vérification d'Ollama
if ! command -v ollama &> /dev/null; then
    echo "🤖 Installation d'Ollama..."
    curl https://ollama.ai/install.sh | sh
fi

# Création de l'environnement virtuel
log "Création de l'environnement virtuel Python..."
python3.11 -m venv backend/venv

# Activation de l'environnement virtuel
source backend/venv/bin/activate

# Installation des dépendances Python
log "Installation des dépendances Python..."
pip install --upgrade pip
pip install -r backend/requirements.txt

# Configuration de Flutter
log "Configuration de Flutter..."
flutter pub get
flutter config --enable-macos-desktop

# Création des dossiers de données
log "Création des dossiers de données..."
mkdir -p ~/Library/Application\ Support/oTo-Memory/user_memory
mkdir -p ~/Library/Application\ Support/oTo-Memory/logs

# Configuration des scripts
log "Configuration des scripts..."
chmod +x scripts/*.sh

# Installation du modèle phi
log "Installation du modèle phi..."
ollama pull phi

success "Installation terminée !"
echo -e "${BLUE}ℹ️  Pour lancer oTo-Memory, utilisez : ./start_oTo.sh${NC}"
echo -e "${BLUE}ℹ️  Pour arrêter : ./stop_oTo.sh${NC}"
echo -e "${BLUE}ℹ️  Pour vérifier l'état : ./memory_status.sh${NC}"
