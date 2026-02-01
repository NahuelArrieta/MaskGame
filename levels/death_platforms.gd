extends TileMapLayer



func _ready():
	enabled = false
	Global.mask_changed.connect(on_mask_changed)

func on_mask_changed(mask: String):
	enabled = mask == Global.MASK_DEATH
	
	
