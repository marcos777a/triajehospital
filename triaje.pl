
% ==========================================
% 1. BASE DE HECHOS
% ==========================================

% paciente(Identificador, Edad).
paciente(p001, 23).
paciente(p002, 70).
paciente(p003, 3).
paciente(p004, 35).


% Síntomas registrados por paciente.
presenta(p001, dolor_cabeza_leve).
presenta(p002, dolor_pecho_intenso).
presenta(p003, dificultad_respirar).
presenta(p004, estornudos).

% Clasificación de síntomas.
sintoma_critico(dolor_pecho_intenso).
sintoma_critico(dificultad_respirar).
sintoma_critico(perdida_consciencia).
sintoma_critico(debilidad_subita).
sintoma_critico(sangrado_incontrolable).

sintoma_leve(moqueo_nasal).
sintoma_leve(estornudos).
sintoma_leve(dolor_garganta_leve).
sintoma_leve(dolor_cabeza_leve).
sintoma_leve(tos_leve).

% Factores de riesgo.
factor_riesgo(hipertension).
factor_riesgo(diabetes).
factor_riesgo(inmunosupresion).
factor_riesgo(enfermedad_cardiaca).
factor_riesgo(edad_avanzada).

% Cantidad inicial de camas disponibles.
:- dynamic camas_disponibles/1.
camas_disponibles(3).


% ==========================================
% 2. REGLAS DE PRIORIDAD
% ==========================================

% Un síntoma crítico siempre activa prioridad 1.
prioridad(P, 1) :-
    paciente(P, _),
    presenta(P, S),
    sintoma_critico(S).

% Vulnerabilidad por edad ante síntomas no críticos.
prioridad(P, 2) :-
    paciente(P, Edad),
    Edad < 5,
    presenta(P, S),
    \+ sintoma_critico(S).

prioridad(P, 2) :-
    paciente(P, Edad),
    Edad > 65,
    presenta(P, S),
    \+ sintoma_critico(S).

% Síntomas moderados: ejemplo de regla académica.
% Se utiliza moderado(S) para registrar esta categoría.
prioridad(P, 3) :-
    paciente(P, _),
    presenta(P, S),
    moderado(S).

% Síntomas leves sin señales de alarma.
prioridad(P, 4) :-
    paciente(P, _),
    presenta(P, S),
    sintoma_leve(S).

% Categoría de ejemplo para síntomas moderados.
moderado(dolor_moderado).
moderado(fiebre_moderada).


% ==========================================
% 3. REGLAS DE ASIGNACIÓN
% ==========================================

% Prioridad 1: requiere valoración inmediata.
asignacion(P, urgencias_inmediatas) :-
    prioridad(P, 1).

% Prioridad 2: evaluación urgente.
asignacion(P, evaluacion_urgente) :-
    prioridad(P, 2).

% Prioridad 3: valoración prioritaria.
asignacion(P, evaluacion_prioritaria) :-
    prioridad(P, 3).

% Prioridad 4: atención de menor urgencia.
asignacion(P, sala_espera_o_ambulatorio) :-
    prioridad(P, 4).


% ==========================================
% 4. CONSULTA DE DISPONIBILIDAD
% ==========================================

hay_cama :-
    camas_disponibles(N),
    N > 0.

% Recomendación si ES prioridad 1 y SÍ hay cama
destino(P, urgencias_con_cama) :- 
    prioridad(P, 1), 
    hay_cama.

% Recomendación si ES prioridad 1 y NO hay cama
destino(P, urgencias_prioritarias_sin_cama) :- 
    prioridad(P, 1), 
    \+ hay_cama.

% Para otras prioridades, se conserva la evaluación clínica.
destino(P, evaluacion_urgente) :- prioridad(P, 2).
destino(P, evaluacion_prioritaria) :- prioridad(P, 3).
destino(P, sala_espera_o_ambulatorio) :- prioridad(P, 4).

