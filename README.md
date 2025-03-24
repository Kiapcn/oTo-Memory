# 🤖 oTo-Memory

Une IA personnelle locale avec mémoire longue, basée sur FastAPI, Ollama (phi) et Flutter.

## 🌟 Fonctionnalités

- 💬 Interface de chat simple et intuitive
- 🧠 Mémoire locale des conversations
- 📊 Historique des sessions par jour
- 🔄 Reprise des conversations précédentes
- 📝 Logs de démarrage et d'erreurs
- 🛑 Arrêt propre de l'application

## 🚀 Installation

1. Cloner le repository :
```bash
git clone [URL_DU_REPO]
cd oTo-Memory
```

2. Installer les dépendances Python :
```bash
cd backend
python -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```

3. Installer Flutter et ses dépendances :
```bash
cd ../frontend/flutter_app
flutter pub get
```

4. Installer Ollama et le modèle phi :
```bash
curl https://ollama.ai/install.sh | sh
ollama pull phi
```

## 🎮 Utilisation

### Démarrage
```bash
./start_oTo.sh
```

### Arrêt
```bash
./stop_oTo.sh
```

### Vérification de l'état
```bash
./memory_status.sh
```

## 📁 Structure du projet

```
oTo-Memory/
├── backend/              # API FastAPI
├── frontend/            # Application Flutter
├── user_memory/         # Stockage des conversations
│   ├── session_*.jsonl  # Fichiers de session
│   └── last_topic.txt   # Dernier sujet discuté
├── logs/                # Logs d'application
├── start_oTo.sh         # Script de démarrage
├── stop_oTo.sh          # Script d'arrêt
└── memory_status.sh     # Script de diagnostic
```

## 🔒 Sécurité

- Les données sont stockées localement
- Pas de connexion internet requise (sauf pour Ollama)
- Les fichiers sensibles sont ignorés par git

## 📝 Logs et mémoire

- Les conversations sont sauvegardées dans `user_memory/session_YYYY-MM-DD.jsonl`
- Le dernier sujet est stocké dans `user_memory/last_topic.txt`
- Les logs de démarrage sont dans `logs/startup.log`

## 🔄 API Endpoints

- `GET /` : Vérification de l'état de l'API
- `GET /last-topic` : Récupération du dernier sujet
- `GET /session-history` : Historique des conversations
- `POST /chat` : Envoi d'un message

## 🛠️ Développement

### Backend
```bash
cd backend
source venv/bin/activate
uvicorn main:app --reload
```

### Frontend
```bash
cd frontend/flutter_app
flutter run -d macos
```

## 📦 Export

Les dossiers suivants sont ignorés lors de l'export :
- `user_memory/`
- `logs/`
- `__pycache__/`
- `.dart_tool/`
- `build/`

## 🤝 Contribution

1. Fork le projet
2. Créer une branche (`git checkout -b feature/AmazingFeature`)
3. Commit les changements (`git commit -m 'Add some AmazingFeature'`)
4. Push vers la branche (`git push origin feature/AmazingFeature`)
5. Ouvrir une Pull Request

