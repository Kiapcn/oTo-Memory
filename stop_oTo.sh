#!/bin/bash
echo "🛑 Arrêt de oTo-Memory v4.0..."

# Sauvegarde de la mémoire si possible
if [ -f "user_memory/last_topic.txt" ]; then
    echo "💾 Sauvegarde de la mémoire..."
    cp user_memory/last_topic.txt user_memory/last_topic.txt.bak
fi

# Log de l'arrêt
echo "$(date '+%Y-%m-%d %H:%M:%S') - Arrêt de oTo-Memory v4.0" >> logs/startup.log

# Fermeture des terminaux
echo "🔒 Fermeture des terminaux..."
osascript <<EOF
tell application "Terminal"
    close (every window whose name contains "uvicorn")
    close (every window whose name contains "ollama")
    close (every window whose name contains "flutter")
end tell
EOF

# Arrêt des processus en arrière-plan
echo "🛑 Arrêt des processus..."
pkill -f "uvicorn main:app"
pkill -f "ollama run phi"
pkill -f "flutter run"

# Vérification que tout est bien arrêté
if pgrep -f "uvicorn main:app" > /dev/null || pgrep -f "ollama run phi" > /dev/null || pgrep -f "flutter run" > /dev/null; then
    echo "⚠️ Certains processus n'ont pas pu être arrêtés. Tentative forcée..."
    pkill -9 -f "uvicorn main:app"
    pkill -9 -f "ollama run phi"
    pkill -9 -f "flutter run"
fi

echo "✅ oTo-Memory a été arrêté proprement."
echo "ℹ️  La mémoire a été sauvegardée dans user_memory/" 