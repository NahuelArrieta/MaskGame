extends CanvasModulate

func _ready():
	Global.mask_changed.connect(on_mask_changed)

func on_mask_changed(mask: String):
	visible = !(mask == Global.MASK_FIRE)
	
