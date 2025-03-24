import json
import os
from datetime import datetime
from pathlib import Path
import re

class MemoryManager:
    def __init__(self):
        self.base_dir = Path(__file__).parent.parent
        self.memory_dir = self.base_dir / "user_memory"
        self.memory_dir.mkdir(exist_ok=True)
        
    def save_conversation(self, user_message: str, phi_response: str):
        """Sauvegarde une conversation dans le fichier de session du jour."""
        session_file = self.memory_dir / f"session_{datetime.now().strftime('%Y-%m-%d')}.jsonl"
        
        # Extraction du sujet principal (première phrase ou premier groupe de mots significatif)
        topic = self._extract_topic(user_message)
        
        conversation = {
            "timestamp": datetime.now().isoformat(),
            "user": user_message,
            "phi": phi_response,
            "topic": topic
        }
        
        with open(session_file, "a", encoding="utf-8") as f:
            f.write(json.dumps(conversation, ensure_ascii=False) + "\n")
            
        # Mise à jour du dernier sujet
        if topic:
            self.save_last_topic(topic)
            
    def _extract_topic(self, message: str) -> str:
        """Extrait le sujet principal du message."""
        # Suppression des caractères spéciaux et normalisation
        message = re.sub(r'[^\w\s]', ' ', message)
        words = message.split()
        
        # Si le message est court, on le prend en entier
        if len(words) <= 3:
            return message.strip()
            
        # Sinon, on prend la première phrase ou les 5 premiers mots
        first_sentence = message.split('.')[0].strip()
        if len(first_sentence.split()) <= 5:
            return first_sentence
        return ' '.join(words[:5])
            
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
        
    def get_recent_sessions(self, days: int = 7) -> list:
        """Récupère les sessions récentes."""
        sessions = []
        for i in range(days):
            date = (datetime.now() - datetime.timedelta(days=i)).strftime("%Y-%m-%d")
            history = self.get_session_history(date)
            if history:
                sessions.append({
                    "date": date,
                    "conversations": history
                })
        return sessions 