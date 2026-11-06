(define (problem roverprob_traction) (:domain Rover-battery)

(:objects
    general - lander
    colour high_res low_res - mode
    rover0 rover1 - rover
    rover0store rover1store - store
    waypoint0 waypoint1 waypoint2 waypoint3 - waypoint
    camera0 - camera
    objective0 objective1 - objective
    b0 b1 b2 b3 b4 b5 - blevel
    bat0 bat1 - battery
    ; Nuevos objetos: tracción, terreno y segundo rover
    wheels tracks - traction
    rocky smooth - terrain
)

(:init
    ; Visibilidad (igual que el original)
    (visible waypoint1 waypoint0) (visible waypoint0 waypoint1)
    (visible waypoint2 waypoint0) (visible waypoint0 waypoint2)
    (visible waypoint2 waypoint1) (visible waypoint1 waypoint2)
    (visible waypoint3 waypoint0) (visible waypoint0 waypoint3)
    (visible waypoint3 waypoint1) (visible waypoint1 waypoint3)
    (visible waypoint3 waypoint2) (visible waypoint2 waypoint3)

    ; Definicion del TERRENO de los caminos
    ; CAMBIOS: Hacemos que TODOS los accesos a waypoint1 sean rocosos (rocky)
    ; para que el rover con ruedas no pueda entrar solo por ningun lado.
    
    (path_type waypoint0 waypoint1 rocky)
    (path_type waypoint1 waypoint0 rocky)
    
    (path_type waypoint3 waypoint1 rocky) ; <--- CAMBIO CLAVE
    (path_type waypoint1 waypoint3 rocky) ; <--- CAMBIO CLAVE
    
    (path_type waypoint2 waypoint1 rocky) ; <--- Por seguridad, tambien este
    (path_type waypoint1 waypoint2 rocky) ; <--- Por seguridad, tambien este
    
    ; El resto siguen siendo llanos (smooth)
    (path_type waypoint0 waypoint3 smooth) (path_type waypoint3 waypoint0 smooth)
    (path_type waypoint2 waypoint3 smooth) (path_type waypoint3 waypoint2 smooth)

    ; Configuracion de ROVERS
    ; Rover0 tiene RUEDAS (no pasa por rocas)
    (at rover0 waypoint0)
    (available rover0)
    (store_of rover0store rover0)
    (empty rover0store)
    (equipped_for_rock_analysis rover0)
    (equipped_for_imaging rover0)
    (equipped_for_traction rover0 wheels)
    (battery_installed rover0 bat0 b4 b4)

    ; Rover1 tiene ORUGAS (si pasa por rocas)
    (at rover1 waypoint2)
    (available rover1)
    (store_of rover1store rover1)
    (empty rover1store)
    (equipped_for_traction rover1 tracks)
    (battery_installed rover1 bat1 b4 b4)

    ; Reglas de TRACCION vs TERRENO
    ; Wheels solo va por smooth
    (can_traverse_traction wheels smooth)
    ; Tracks va por todo
    (can_traverse_traction tracks smooth)
    (can_traverse_traction tracks rocky)

    ; Configuracion general (Lander, camaras, baterias)
    (at_lander general waypoint2)
    (channel_free general)

    (on_board camera0 rover0)
    (calibration_target camera0 objective1)
    (supports camera0 colour)
    (supports camera0 high_res)

    (at_rock_sample waypoint1) ; Objetivo en zona rocosa

    (lower b0 b1) (lower b1 b2) (lower b2 b3) (lower b3 b4) (lower b4 b5)

    (visible_from objective0 waypoint0)
    (visible_from objective0 waypoint1)
    (visible_from objective0 waypoint2)
    (visible_from objective0 waypoint3)
    (visible_from objective1 waypoint0)
    (visible_from objective1 waypoint1)
    (visible_from objective1 waypoint2)
)

(:goal (and
    ; El objetivo es que rover0 analice la roca en wp1.
    ; Como rover0 tiene ruedas y el camino a wp1 es rocoso,
    ; rover1 tendra que venir a buscarlo y remolcarlo (tow).
    (communicated_rock_data waypoint1)
    (at rover0 waypoint1) 
))
)