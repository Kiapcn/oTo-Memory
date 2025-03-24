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
BACKUP_DIR="$SUPPORT_DIR/backups"

# Créer le dossier de backup s'il n'existe pas
mkdir -p "$BACKUP_DIR"

# Sauvegarder les données actuelles
BACKUP_NAME="backup_$(date '+%Y%m%d_%H%M%S')"
log "Création d'une sauvegarde des données..."
cp -r "$SUPPORT_DIR/user_memory" "$BACKUP_DIR/$BACKUP_NAME"

# Arrêter l'application si elle est en cours d'exécution
if pgrep -f "uvicorn main:app" > /dev/null || pgrep -f "flutter run" > /dev/null; then
    log "Arrêt de l'application en cours..."
    ./stop_oTo.sh
fi

# Vérifier si Git est installé
if ! command -v git &> /dev/null; then
    error "Git n'est pas installé. Veuillez l'installer via https://git-scm.com"
    exit 1
fi

# Mettre à jour le code source
log "Mise à jour du code source..."
if [ -d ".git" ]; then
    git pull origin main
else
    error "Ce dossier n'est pas un dépôt Git"
    exit 1
fi

# Mettre à jour les dépendances
log "Mise à jour des dépendances..."
cd backend
pip3 install -r requirements.txt
cd ../frontend/flutter_app
flutter pub get
cd ../..

# Recompiler l'application
log "Recompilation de l'application..."
./build_macos_app.sh

# Copier la nouvelle version dans Applications
log "Installation de la nouvelle version..."
cp -r "build/ready_to_export/oTo-Memory.app" "/Applications/"

# Nettoyer les anciennes sauvegardes (garder les 5 dernières)
cd "$BACKUP_DIR"
ls -t | tail -n +6 | xargs -r rm -rf

log "Mise à jour terminée avec succès"
log "Vous pouvez maintenant lancer la nouvelle version depuis le Launchpad" 