extends CharacterBody2D

@export var speed = 70.0
@export var jump_velocity = -450.0

var current_mask: String = Global.MASK_NONE
var gravity_direction = 1

func _ready():
	Global.mask_changed.connect(on_mask_changed)
	

func _process(_delta):
	for action in Global.mask_map.keys():
		if Input.is_action_just_pressed(action):
			var selected = Global.mask_map[action]
			if selected != current_mask:
				current_mask = selected
			else:
				current_mask = Global.MASK_NONE
			Global.mask_changed.emit(current_mask)
			break

func _physics_process(delta):
	
	if not is_on_the_floor():
		velocity.y += Global.gravity * delta * gravity_direction
		
	

	if is_on_the_floor() and Input.is_action_just_pressed("JUMP"):
		velocity.y = jump_velocity * gravity_direction 
		# $Jump.play()
	

	var direction = Input.get_axis("LEFT",  "RIGHT") 
	velocity.x = direction * speed * gravity_direction
	
	move_and_slide()
	update_animation()
	

func update_animation():
	# Definimos el sufijo para no repetir código
	var anim_suffix = str(current_mask)

	if not is_on_the_floor():
		# Corregido: Usamos strings reales "texto" + variable
		$Animation.play("up_" + anim_suffix)

		if velocity.x != 0:
			$Animation.flip_h = velocity.x < 0
		return 

	if velocity.x == 0:
		var idle_anim = "idle_" + anim_suffix
		if $Animation.animation != idle_anim:
			$Animation.play(idle_anim)
	else:
		var walk_anim = "left_" + anim_suffix 
		if $Animation.animation != walk_anim:
			$Animation.play(walk_anim)
		
		$Animation.flip_h = velocity.x < 0
		
func on_mask_changed(mask: String):
	## Fire mask
	$Light.visible = !(mask == Global.MASK_FIRE)
	
	## Gravity mask
	if mask == Global.MASK_ANTIGRAVITY:
		gravity_direction = -1
		$Animation.flip_v = true
	else:
		gravity_direction = 1
		$Animation.flip_v = false
	
	update_animation()
	
func is_on_the_floor():
	if gravity_direction == 1:
		return is_on_floor()
	else:
		return is_on_ceiling()
		
func die() -> void:
	set_physics_process(false)
	
	get_tree().reload_current_scene()
	
func touch_water() -> void:
	if current_mask == Global.MASK_FIRE:
		die()
