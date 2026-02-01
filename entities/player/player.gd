extends CharacterBody2D

@export var speed = 70.0
@export var jump_velocity = -450.0


var current_mask: String = ""
var gravity_direction = 1

func _ready():
	Global.mask_changed.connect(on_mask_changed)


	


func _process(_delta):
	for action in Global.mask_map.keys():
		if Input.is_action_just_pressed(action):
			var selected = Global.mask_map[action]
			if selected != current_mask:
				current_mask = selected
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
	# 1. ESTADO: EN EL AIRE
	if not is_on_floor():
		$Animation.play("up_normal")

		
		# Permitir giro en el aire
		if velocity.x != 0:
			$Animation.flip_h = velocity.x < 0
		
		# Salimos de la función para no tocar nada del suelo
		return 

	# 2. ESTADO: EN EL SUELO (Solo llega aquí si is_on_floor es true)
	if velocity.x == 0:
		if $Animation.animation != "idle_normal":
			$Animation.play("idle_normal")
	else:
		if $Animation.animation != "left_normal":
			$Animation.play("left_normal")
		
		# Voltear según dirección al caminar
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
	
func is_on_the_floor():
	if gravity_direction == 1:
		return is_on_floor()
	else:
		return is_on_ceiling()
