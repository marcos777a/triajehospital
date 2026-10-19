from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from pyswip import Prolog

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"], 
    allow_methods=["*"],
    allow_headers=["*"],
)

prolog = Prolog()
prolog.consult("triaje.pl")

@app.get("/evaluar_todos")
def evaluar_todos():
    try:
        consulta = "destino(Paciente, Destino)"
        resultados = list(prolog.query(consulta))
        
        lista_pacientes = []
        for res in resultados:
            lista_pacientes.append({
                "paciente": str(res["Paciente"]),
                "alerta_medica": str(res["Destino"])
            })
            
        return {
            "estado": "exito", 
            "total_evaluados": len(lista_pacientes),
            "resultados": lista_pacientes
        }
    except Exception as e:
        return {
            "estado": "error",
            "mensaje": f"Error: {str(e)}"
        }
