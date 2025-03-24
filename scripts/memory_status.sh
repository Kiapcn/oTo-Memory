#!/bin/bash
echo "📊 État de la mémoire oTo-Memory"

# Nombre de sessions
echo "📁 Sessions sauvegardées :"
ls -1 user_memory/session_*.jsonl 2>/dev/null | wc -l

# Taille du dossier user_memory
echo "📦 Taille du dossier user_memory :"
du -sh user_memory/

# Dernier sujet en mémoire
if [ -f "user_memory/last_topic.txt" ]; then
    echo "🧠 Dernier sujet discuté :"
    cat user_memory/last_topic.txt
else
    echo "🧠 Aucun sujet en mémoire"
fi

# Liste des fichiers analysés
echo "📋 Fichiers de session :"
ls -l user_memory/session_*.jsonl 2>/dev/null || echo "Aucun fichier de session trouvé"

# État des logs
echo "📝 Derniers logs :"
tail -n 5 logs/startup.log 2>/dev/null || echo "Aucun log trouvé" 