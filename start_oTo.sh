#!/bin/bash
echo "🚀 Lancement complet de oTo-Memory v4.0..."

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Vérification de l'environnement
if ! command -v ollama &> /dev/null; then
    echo "❌ Erreur: Ollama n'est pas installé. Exécutez d'abord install_mac.sh"
    exit 1
fi

if ! command -v flutter &> /dev/null; then
    echo "❌ Erreur: Flutter n'est pas installé. Exécutez d'abord install_mac.sh"
    exit 1
fi

# Création des dossiers nécessaires
mkdir -p user_memory logs

# Vérification de l'existence des dossiers nécessaires
if [ ! -d "$DIR/backend" ] || [ ! -d "$DIR/frontend/flutter_app" ]; then
    echo "❌ Erreur: Structure du projet incorrecte"
    exit 1
fi

# Log du démarrage
echo "$(date '+%Y-%m-%d %H:%M:%S') - Démarrage de oTo-Memory v4.0" >> logs/startup.log

# Vérification du dernier sujet
if [ -f "user_memory/last_topic.txt" ]; then
    LAST_TOPIC=$(cat user_memory/last_topic.txt)
    echo "🧠 La dernière fois, on parlait de : $LAST_TOPIC"
    echo "Veux-tu continuer cette discussion ou démarrer autre chose ? (o/n)"
    read -r response
    if [[ "$response" =~ ^[Oo]$ ]]; then
        echo "✅ Continuation de la conversation sur : $LAST_TOPIC"
        # Sauvegarde du contexte précédent
        cp user_memory/last_topic.txt user_memory/last_topic.txt.bak
    else
        echo "🔄 Démarrage d'une nouvelle conversation..."
        # Sauvegarde de l'ancien sujet avant de le supprimer
        cp user_memory/last_topic.txt "user_memory/last_topic_$(date '+%Y%m%d').txt"
        rm user_memory/last_topic.txt
    fi
else
    echo "✨ Nouvelle session - Aucune conversation précédente"
fi

# Création du fichier de session du jour
SESSION_FILE="user_memory/session_$(date '+%Y-%m-%d').jsonl"
touch "$SESSION_FILE"

# Vérification de l'environnement Python
if [ ! -d "$DIR/backend/venv" ]; then
    echo "❌ Erreur: Environnement Python non configuré. Exécutez d'abord install_mac.sh"
    exit 1
fi

# Lancement du backend FastAPI
echo "📡 Lancement du backend FastAPI..."
osascript <<EOF
tell application "Terminal"
    do script "cd $DIR/backend && source venv/bin/activate && uvicorn main:app --reload --port 8000"
end tell
EOF
sleep 3

# Vérification que le modèle phi est installé
if ! ollama list | grep -q "phi"; then
    echo "🧠 Installation du modèle phi..."
    ollama pull phi
fi

# Lancement d'Ollama
echo "🤖 Lancement d'Ollama..."
osascript <<EOF
tell application "Terminal"
    do script "cd $DIR && ollama run phi"
end tell
EOF
sleep 3

# Lancement de l'application Flutter
echo "📱 Lancement de l'application Flutter..."
osascript <<EOF
tell application "Terminal"
    do script "cd $DIR/frontend/flutter_app && flutter clean && flutter pub get && flutter run -d macos"
end tell
EOF

echo "✅ Tout est lancé dans 3 terminaux."
echo "ℹ️  Le backend est accessible sur http://localhost:8000"
echo "ℹ️  L'application Flutter devrait s'ouvrir automatiquement"
echo "📝 Les logs sont disponibles dans logs/startup.log"
echo "💾 Les sessions sont sauvegardées dans user_memory/"
