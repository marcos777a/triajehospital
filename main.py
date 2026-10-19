
from fastapi import FastAPI

app = FastAPI(title="Sistema de Triaje")

@app.get("/")
def inicio():
    return {
        "mensaje": "Sistema de triaje funcionando",
        "estado": "OK"
    }

@app.get("/salud")
def salud():
    return {"api": "activa"}
