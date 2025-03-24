from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
import httpx
from memory_manager import MemoryManager
from datetime import datetime

app = FastAPI()
memory_manager = MemoryManager()

# Configuration CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

class Message(BaseModel):
    text: str

@app.get("/")
async def read_root():
    return {
        "status": "ok",
        "message": "oTo-Memory API is running",
        "last_topic": memory_manager.get_last_topic()
    }

@app.get("/last-topic")
async def get_last_topic():
    return {"topic": memory_manager.get_last_topic()}

@app.get("/session-history")
async def get_session_history(date: str = None):
    return {"history": memory_manager.get_session_history(date)}

@app.get("/recent-sessions")
async def get_recent_sessions(days: int = 7):
    return {"sessions": memory_manager.get_recent_sessions(days)}

@app.post("/chat")
async def chat(message: Message):
    try:
        # Appel à Ollama
        async with httpx.AsyncClient() as client:
            response = await client.post(
                "http://localhost:11434/api/generate",
                json={
                    "model": "phi",
                    "prompt": message.text,
                    "stream": False
                }
            )
            
            if response.status_code != 200:
                raise HTTPException(status_code=500, detail="Erreur lors de l'appel à Ollama")
                
            phi_response = response.json()["response"]
            
            # Sauvegarde de la conversation
            memory_manager.save_conversation(message.text, phi_response)
            
            return {
                "response": phi_response,
                "timestamp": datetime.now().isoformat(),
                "topic": memory_manager.get_last_topic()
            }
            
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
