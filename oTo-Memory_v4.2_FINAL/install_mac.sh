#!/bin/bash
echo "🚀 Installation de oTo-Memory v4.0..."

# Vérification de Python
if ! command -v python3 &> /dev/null; then
    echo "❌ Python 3 n'est pas installé. Installation via Homebrew..."
    if ! command -v brew &> /dev/null; then
        echo "📦 Installation de Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    brew install python
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

# Création de l'environnement Python
echo "🐍 Configuration de l'environnement Python..."
cd backend
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
cd ..

# Configuration de Flutter
echo "📦 Configuration de Flutter..."
cd frontend/flutter_app
flutter pub get
flutter config --enable-macos-desktop
cd ../..

# Création des dossiers nécessaires
echo "📁 Création des dossiers de données..."
mkdir -p user_memory logs

# Rendre les scripts exécutables
echo "🔧 Configuration des scripts..."
chmod +x start_oTo.sh stop_oTo.sh memory_status.sh

# Installation du modèle phi pour Ollama
echo "🧠 Installation du modèle phi..."
ollama pull phi

echo "✅ Installation terminée !"
echo "ℹ️  Pour lancer oTo-Memory, utilisez : ./start_oTo.sh"
echo "ℹ️  Pour arrêter : ./stop_oTo.sh"
echo "ℹ️  Pour vérifier l'état : ./memory_status.sh"
