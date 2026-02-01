extends Control

# Colores para el estado
var color_activo = Color(1, 1, 1, 1)      # Blanco intenso
var color_inactivo = Color(0.4, 0.4, 0.4, 1) # Grisaceo/Oscuro

const mask_order = [
	 Global.MASK_FIRE,
	 Global.MASK_DEATH,
	 Global.MASK_ANTIGRAVITY
]

func _ready():
	actualizar_seleccion(-1)
	Global.mask_changed.connect(on_mask_changed)
	
func on_mask_changed(mask): 
	for i in range(mask_order.size()):
		if mask_order[i] == mask:
			actualizar_seleccion(i)
			return
	actualizar_seleccion(-1)	

	

func actualizar_seleccion(indice_elegido: int):
	var masks = get_children()
	
	for i in range(masks.size()):
		if i == indice_elegido:
			masks[i].self_modulate = color_activo
			
		else:
			masks[i].self_modulate = color_inactivo
			
