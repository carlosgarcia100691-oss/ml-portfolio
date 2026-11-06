(define (problem roverprob1234) (:domain Rover-battery)
(:objects
	general - Lander
	colour high_res low_res - Mode
	; Segundo rover para anadir nuevo rover
	rover0 rover1 - Rover
	; Segundo rover para anadir un almacen al rover1
	rover0store rover1store - Store
	waypoint0 waypoint1 waypoint2 waypoint3 - Waypoint
	; Segundo rover para anadir una camara adicional
	camera0 camera1 - Camera
	objective0 objective1 - Objective
    b0 b1 b2 b3 b4 b5 - Blevel
    ; Segundo rover para anadir bateria del rover1
	bat0 bat1 - Battery
	)
(:init
	(visible waypoint1 waypoint0)
	(visible waypoint0 waypoint1)
	(visible waypoint2 waypoint0)
	(visible waypoint0 waypoint2)
	(visible waypoint2 waypoint1)
	(visible waypoint1 waypoint2)
	(visible waypoint3 waypoint0)
	(visible waypoint0 waypoint3)
	(visible waypoint3 waypoint1)
	(visible waypoint1 waypoint3)
	(visible waypoint3 waypoint2)
	(visible waypoint2 waypoint3)
	(at_soil_sample waypoint0)
	(at_rock_sample waypoint1)
	(at_soil_sample waypoint2)
	(at_rock_sample waypoint2)
	(at_soil_sample waypoint3)
	(at_rock_sample waypoint3)
	(at_lander general waypoint0)
	(channel_free general)
	(at rover0 waypoint3)
	(available rover0)
	; Segundo rover para anadir nueva posicion y disponibilidad
	(at rover1 waypoint3)
	(available rover1)
	; ------------------------------------------------------------------------
	(store_of rover0store rover0)
	(empty rover0store)
	; Segundo rover para disponibilizar el almacen
	(store_of rover1store rover1)
	(empty rover1store)
	; ------------------------------------------------------------------------
	(equipped_for_soil_analysis rover0)
	(equipped_for_rock_analysis rover0)
	(equipped_for_imaging rover0)
	; Segundo rover para definir capacidades del rover1
	(equipped_for_soil_analysis rover1)
	(equipped_for_rock_analysis rover1)
	(equipped_for_imaging rover1)
	; ------------------------------------------------------------------------
	(can_traverse rover0 waypoint3 waypoint0)
	(can_traverse rover0 waypoint0 waypoint3)
	(can_traverse rover0 waypoint3 waypoint1)
	(can_traverse rover0 waypoint1 waypoint3)
	(can_traverse rover0 waypoint1 waypoint2)
	(can_traverse rover0 waypoint2 waypoint1)
	; Segundo rover para permitir movimiento del rover1
	(can_traverse rover1 waypoint3 waypoint0)
	(can_traverse rover1 waypoint0 waypoint3)
	(can_traverse rover1 waypoint3 waypoint1)
	(can_traverse rover1 waypoint1 waypoint3)
	(can_traverse rover1 waypoint1 waypoint2)
	(can_traverse rover1 waypoint2 waypoint1)
	; ------------------------------------------------------------------------
	(on_board camera0 rover0)
	(calibration_target camera0 objective1)
	(supports camera0 colour)
	(supports camera0 high_res)
	; Segundo rover para disponibilizar la camara1 -----------------------------
	(on_board camera1 rover1)
	(calibration_target camera1 objective1)
	(supports camera1 colour)
	(supports camera1 high_res)
	(supports camera1 low_res)
	(supports camera0 low_res) ; para que la camara0 soporte el modo low_res
	; ------------------------------------------------------------------------
	; Bateria cargada en rover 0
	(battery_installed rover0 bat0 b4 b4)
	; Segundo rover para cargar la bateria en rover1
	(battery_installed rover1 bat1 b4 b4) 
	; ------------------------------------------------------------------------
	; Niveles de bateria
	(lower b0 b1) (lower b1 b2) (lower b2 b3) (lower b3 b4) (lower b4 b5)
	; Visibilidad de objetivos
	(visible_from objective0 waypoint0)
	(visible_from objective0 waypoint1)
	(visible_from objective0 waypoint2)
	(visible_from objective0 waypoint3)
	(visible_from objective1 waypoint0)
	(visible_from objective1 waypoint1)
	(visible_from objective1 waypoint2)
)

(:goal (and
   (communicated_soil_data waypoint2)
   (communicated_rock_data waypoint3)
   (communicated_image_data objective1 high_res)
	; Segundo rover objetivos adicionales para comunicar todas las muestras de suelo y roca
   (communicated_soil_data waypoint0)
   (communicated_soil_data waypoint3)
   (communicated_rock_data waypoint1)
   (communicated_rock_data waypoint2)
	; ------------------------------------------------------------------------
	; Segundo rover objetivos adicionales para sacar fotos de todos los objetivos en ambos modos
   (communicated_image_data objective0 high_res)
   (communicated_image_data objective0 low_res)
   (communicated_image_data objective1 low_res)
	; ------------------------------------------------------------------------	
   )
)
)
