import os
import json
import shutil
from pathlib import Path
from datetime import datetime

class UserDataManager:
    def __init__(self):
        self.app_support_dir = Path.home() / "Library/Application Support/oTo-Memory"
        self.memory_dir = self.app_support_dir / "user_memory"
        self.logs_dir = self.app_support_dir / "logs"
        self.setup_directories()
        
    def setup_directories(self):
        """Crée la structure de dossiers nécessaire."""
        self.memory_dir.mkdir(parents=True, exist_ok=True)
        self.logs_dir.mkdir(parents=True, exist_ok=True)
        
        # Création du README utilisateur s'il n'existe pas
        readme_path = self.app_support_dir / "README_user.txt"
        if not readme_path.exists():
            self.create_user_readme()
            
    def create_user_readme(self):
        """Crée le fichier README pour l'utilisateur."""
        readme_content = """# 📖 Guide d'utilisation de oTo-Memory

## 🎯 À propos
oTo-Memory est votre assistant IA personnel qui apprend et évolue avec vous. Toutes vos conversations sont sauvegardées localement et en toute sécurité.

## 📁 Structure des données
- `user_memory/` : Contient vos conversations et souvenirs
  - `session_YYYY-MM-DD.jsonl` : Historique des conversations par jour
  - `last_topic.txt` : Dernier sujet discuté
- `logs/` : Fichiers de log pour le diagnostic

## 🔄 Fonctionnalités
- Sauvegarde automatique des conversations
- Reprise des discussions précédentes
- Apprentissage continu
- Confidentialité totale (données locales uniquement)

## 🛠️ Maintenance
- Les données sont sauvegardées dans ~/Library/Application Support/oTo-Memory/
- Vous pouvez sauvegarder ce dossier pour préserver vos conversations
- Les mises à jour de l'application ne touchent pas à vos données

## 📝 Notes
- L'application utilise le modèle phi d'Ollama pour le traitement local
- Toutes les données sont stockées sur votre machine uniquement
- Aucune connexion internet n'est requise (sauf pour les mises à jour)
"""
        with open(self.app_support_dir / "README_user.txt", "w", encoding="utf-8") as f:
            f.write(readme_content)
            
    def save_conversation(self, user_message: str, phi_response: str):
        """Sauvegarde une conversation dans le fichier de session du jour."""
        session_file = self.memory_dir / f"session_{datetime.now().strftime('%Y-%m-%d')}.jsonl"
        
        conversation = {
            "timestamp": datetime.now().isoformat(),
            "user": user_message,
            "phi": phi_response
        }
        
        with open(session_file, "a", encoding="utf-8") as f:
            f.write(json.dumps(conversation, ensure_ascii=False) + "\n")
            
    def save_last_topic(self, topic: str):
        """Sauvegarde le dernier sujet discuté."""
        topic_file = self.memory_dir / "last_topic.txt"
        with open(topic_file, "w", encoding="utf-8") as f:
            f.write(topic)
            
    def get_last_topic(self) -> str:
        """Récupère le dernier sujet discuté."""
        topic_file = self.memory_dir / "last_topic.txt"
        if topic_file.exists():
            return topic_file.read_text(encoding="utf-8").strip()
        return ""
        
    def get_session_history(self, date: str = None) -> list:
        """Récupère l'historique d'une session."""
        if date is None:
            date = datetime.now().strftime("%Y-%m-%d")
            
        session_file = self.memory_dir / f"session_{date}.jsonl"
        if not session_file.exists():
            return []
            
        history = []
        with open(session_file, "r", encoding="utf-8") as f:
            for line in f:
                history.append(json.loads(line))
        return history
        
    def backup_user_data(self):
        """Crée une sauvegarde des données utilisateur."""
        backup_dir = self.app_support_dir / "backups"
        backup_dir.mkdir(exist_ok=True)
        
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        backup_path = backup_dir / f"backup_{timestamp}"
        
        shutil.copytree(self.memory_dir, backup_path / "user_memory")
        shutil.copytree(self.logs_dir, backup_path / "logs")
        
        return backup_path
        
    def restore_user_data(self, backup_path: Path):
        """Restaure une sauvegarde des données utilisateur."""
        if not backup_path.exists():
            return False
            
        # Sauvegarde de sécurité avant restauration
        self.backup_user_data()
        
        # Restauration des données
        shutil.rmtree(self.memory_dir)
        shutil.rmtree(self.logs_dir)
        shutil.copytree(backup_path / "user_memory", self.memory_dir)
        shutil.copytree(backup_path / "logs", self.logs_dir)
        
        return True 