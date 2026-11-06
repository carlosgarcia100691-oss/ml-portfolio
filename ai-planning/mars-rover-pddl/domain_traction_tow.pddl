(define (domain Rover-battery)
(:requirements :typing :strips)
(:types rover waypoint store camera mode lander objective
    blevel battery traction terrain
)

(:predicates (at ?x - rover ?y - waypoint)
    (at_lander ?x - lander ?y - waypoint)
    
    ; Eliminado el antiguo can_traverse directo
    ; Nuevos predicados para terreno y traccion
    (path_type ?x - waypoint ?y - waypoint ?t - terrain)
    (equipped_for_traction ?r - rover ?t - traction)
    (can_traverse_traction ?tr - traction ?te - terrain)

    (equipped_for_soil_analysis ?r - rover)
    (equipped_for_rock_analysis ?r - rover)
    (equipped_for_imaging ?r - rover)
    (empty ?s - store)
    (have_rock_analysis ?r - rover ?w - waypoint)
    (have_soil_analysis ?r - rover ?w - waypoint)
    (full ?s - store)
    (calibrated ?c - camera ?r - rover)
    (supports ?c - camera ?m - mode)
    (available ?r - rover)
    (visible ?w - waypoint ?p - waypoint)
    (have_image ?r - rover ?o - objective ?m - mode)
    (communicated_soil_data ?w - waypoint)
    (communicated_rock_data ?w - waypoint)
    (communicated_image_data ?o - objective ?m - mode)
    (at_soil_sample ?w - waypoint)
    (at_rock_sample ?w - waypoint)
    (visible_from ?o - objective ?w - waypoint)
    (store_of ?s - store ?r - rover)
    (calibration_target ?i - camera ?o - objective)
    (on_board ?i - camera ?r - rover)
    (channel_free ?l - lander)
    (battery_installed ?r - rover ?b - battery ?bmax ?bcur - blevel)
    (lower ?l1 ?l2 - blevel)
)

; Modificado para incluir restriccion de terreno y traccion
(:action navigate-bat
    :parameters (?r - rover ?y - waypoint ?z - waypoint 
                 ?b - battery ?bmax ?bcur ?bnext - blevel
                 ?tr - traction ?te - terrain)
    :precondition (and 
        (available ?r) 
        (at ?r ?y)
        (visible ?y ?z)
        (path_type ?y ?z ?te)                 ; El camino es de tipo ?te
        (equipped_for_traction ?r ?tr)        ; El rover tiene traccion ?tr
        (can_traverse_traction ?tr ?te)       ; Esa traccion sirve para ese terreno
        (battery_installed ?r ?b ?bmax ?bcur)
        (lower ?bnext ?bcur)
    )
    :effect (and 
        (not (at ?r ?y)) 
        (at ?r ?z)
        (not (battery_installed ?r ?b ?bmax ?bcur)) 
        (battery_installed ?r ?b ?bmax ?bnext)
    )
)

; Nueva accion de remolcar (Tow)
; Solo gasta bateria el rover r1 (el que remolca)
; El rover r2 (remolcado) se mueve sin comprobar su traccion
(:action tow
    :parameters (?r1 - rover ?r2 - rover 
                 ?y - waypoint ?z - waypoint 
                 ?b - battery ?bmax ?bcur ?bnext - blevel
                 ?tr - traction ?te - terrain)
    :precondition (and 
        (available ?r1) (available ?r2)
        (at ?r1 ?y) (at ?r2 ?y)               ; Ambos estan en el origen
        (visible ?y ?z)
        (path_type ?y ?z ?te)                 ; El camino es de tipo ?te
        (equipped_for_traction ?r1 ?tr)       ; El remolcador r1 tiene traccion ?tr
        (can_traverse_traction ?tr ?te)       ; r1 puede cruzar
        ; No comprobamos traccion de r2 porque va remolcado
        (battery_installed ?r1 ?b ?bmax ?bcur); Bateria del remolcador
        (lower ?bnext ?bcur)
    )
    :effect (and 
        (not (at ?r1 ?y)) (at ?r1 ?z)         ; Mueve r1
        (not (at ?r2 ?y)) (at ?r2 ?z)         ; Mueve r2
        (not (battery_installed ?r1 ?b ?bmax ?bcur)) 
        (battery_installed ?r1 ?b ?bmax ?bnext) ; Gasta bateria r1
    )
)

; Resto de acciones sin cambios significativos
(:action recharge
    :parameters (?r - rover ?l - lander ?w - waypoint 
                 ?b - battery ?bmax ?bcur - blevel)
    :precondition (and (at ?r ?w) (at_lander ?l ?w) 
                  (battery_installed ?r ?b ?bmax ?bcur))
    :effect (and (not (battery_installed ?r ?b ?bmax ?bcur)) 
                 (battery_installed ?r ?b ?bmax ?bmax))
)

(:action sample_soil
    :parameters (?r - rover ?s - store ?p - waypoint)
    :precondition (and (at ?r ?p) (at_soil_sample ?p) (equipped_for_soil_analysis ?r) (store_of ?s ?r) (empty ?s))
    :effect (and (not (empty ?s)) (full ?s) (have_soil_analysis ?r ?p) (not (at_soil_sample ?p)))
)

(:action sample_rock
    :parameters (?r - rover ?s - store ?p - waypoint)
    :precondition (and (at ?r ?p) (at_rock_sample ?p) (equipped_for_rock_analysis ?r) (store_of ?s ?r)(empty ?s))
    :effect (and (not (empty ?s)) (full ?s) (have_rock_analysis ?r ?p) (not (at_rock_sample ?p)))
)

(:action drop
    :parameters (?r - rover ?s - store)
    :precondition (and (store_of ?s ?r) (full ?s))
    :effect (and (not (full ?s)) (empty ?s))
)

(:action calibrate
    :parameters (?r - rover ?i - camera ?t - objective ?w - waypoint)
    :precondition (and (equipped_for_imaging ?r) (calibration_target ?i ?t) (at ?r ?w) (visible_from ?t ?w)(on_board ?i ?r))
    :effect (calibrated ?i ?r)
)

(:action take_image
    :parameters (?r - rover ?p - waypoint ?o - objective ?i - camera ?m - mode)
    :precondition (and (calibrated ?i ?r) (on_board ?i ?r) (equipped_for_imaging ?r) (supports ?i ?m) (visible_from ?o ?p) (at ?r ?p))
    :effect (and (have_image ?r ?o ?m)(not (calibrated ?i ?r)))
)

(:action communicate_soil_data
    :parameters (?r - rover ?l - lander ?p - waypoint ?x - waypoint ?y - waypoint)
    :precondition (and (at ?r ?x)(at_lander ?l ?y)(have_soil_analysis ?r ?p) 
                   (visible ?x ?y)(available ?r)(channel_free ?l))
    :effect (and (not (available ?r))(not (channel_free ?l))(channel_free ?l)
                 (communicated_soil_data ?p)(available ?r))
)

(:action communicate_rock_data
    :parameters (?r - rover ?l - lander ?p - waypoint ?x - waypoint ?y - waypoint)
    :precondition (and (at ?r ?x)(at_lander ?l ?y)(have_rock_analysis ?r ?p)
                   (visible ?x ?y)(available ?r)(channel_free ?l))
    :effect (and (not (available ?r))(not (channel_free ?l))(channel_free ?l)(communicated_rock_data ?p)(available ?r))
)

(:action communicate_image_data
    :parameters (?r - rover ?l - lander ?o - objective ?m - mode ?x - waypoint ?y - waypoint)
    :precondition (and (at ?r ?x)(at_lander ?l ?y)(have_image ?r ?o ?m)(visible ?x ?y)(available ?r)(channel_free ?l))
    :effect (and (not (available ?r))(not (channel_free ?l))(channel_free ?l)(communicated_image_data ?o ?m)(available ?r))
)
)