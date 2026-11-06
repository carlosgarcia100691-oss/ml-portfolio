# Planificación automática para un rover marciano (PDDL)

Modelado y resolución en **PDDL** de misiones para rovers con batería limitada: tomar
muestras de suelo y roca, fotografiar objetivos y comunicar los datos al módulo de
aterrizaje. Los problemas se resuelven con el planificador **LAMA-First** (Fast Downward).

**Stack:** PDDL · Fast Downward / LAMA · VS Code (extensión PDDL)

## Escenarios

| Fichero | Escenario | Plan obtenido |
|---|---|---|
| — | Problema base (1 rover, 4 waypoints) | 12 acciones; 17 estados expandidos, 0 callejones sin salida |
| [`problem_new_waypoint.pddl`](problem_new_waypoint.pddl) | Nuevo waypoint con muestras de suelo y roca, y el rover debe terminar en `waypoint1` | 18 acciones; 412 estados expandidos, 440 callejones sin salida |
| [`problem_two_rovers.pddl`](problem_two_rovers.pddl) | Segundo rover, todas las muestras y fotografías en ambos modos | 34 acciones repartidas entre los dos rovers |
| [`domain_traction_tow.pddl`](domain_traction_tow.pddl) + [`problem_traction_tow.pddl`](problem_traction_tow.pddl) | Dominio ampliado con terrenos, tracción y **remolque** | — |

## Ampliación del dominio: terreno, tracción y remolque

- **Nuevos tipos** `traction` (ruedas, orugas) y `terrain` (rocoso, liso).
- El predicado estático `can_traverse` se sustituye por `path_type`,
  `equipped_for_traction` y `can_traverse_traction`. Un rover solo puede moverse si su
  tracción es compatible con el terreno del camino.
- **Nueva acción `tow`:** un rover remolca a otro hasta el destino. Solo se comprueba la
  tracción del remolcador y solo él consume batería.

```pddl
(:action tow
  :parameters (?r1 - rover ?r2 - rover ?y - waypoint ?z - waypoint
               ?b - battery ?bmax ?bcur ?bnext - blevel
               ?tr - traction ?te - terrain)
  :precondition (and (available ?r1) (available ?r2)
                     (at ?r1 ?y) (at ?r2 ?y) (visible ?y ?z)
                     (path_type ?y ?z ?te)
                     (equipped_for_traction ?r1 ?tr)
                     (can_traverse_traction ?tr ?te)
                     (battery_installed ?r1 ?b ?bmax ?bcur) (lower ?bnext ?bcur))
  ...)
```

En el problema de prueba, `rover0` tiene ruedas y el camino hasta la roca es rocoso, así que
el planificador debe recurrir a que `rover1`, con orugas, lo remolque.

## Análisis del planificador

- LAMA traduce el problema a una representación de dominio finito, extrae **landmarks**
  (18 en el problema base) y realiza una búsqueda *greedy best-first* que alterna las
  heurísticas de landmarks y **FF**.
- Es un planificador *satisficing*: encuentra planes válidos rápidamente, pero no
  necesariamente óptimos. En el problema base, por ejemplo, el plan agota la batería
  (b4 → b0) porque nada le obliga a conservarla.
- Con dos rovers, el reparto de tareas es razonable pero no minimiza los desplazamientos
  totales: los dos rovers pasan por zonas comunes.
