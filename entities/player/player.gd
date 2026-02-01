extends CharacterBody2D

@export var speed = 70.0
@export var jump_velocity = -450.0
@export var is_dead: bool = false

@onready var player_light: PointLight2D = $Light


var current_mask: String = Global.MASK_NONE
var gravity_direction = 1

var death_mask_energy: float = 100.0   
var death_mask_energy_consume_speed: float = 10.0 
var death_mask_energyregen_speed: float = 10.0
var current_death_mask_energy: float = 100.0




func _ready():
	Global.mask_changed.connect(on_mask_changed)
	
	update_animation()
	Global.mask_changed.emit(current_mask)
	

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
			
	var is_using_death_mask = current_mask == Global.MASK_DEATH
	
	if is_using_death_mask and current_death_mask_energy > 0:
		current_death_mask_energy -= death_mask_energy_consume_speed * _delta
		if current_death_mask_energy <= 0:
			current_death_mask_energy = 0
			die() 
		player_light.color = Color.WHITE.lerp(Color("072c21"), (100 - current_death_mask_energy)/100)	
	elif not is_using_death_mask and current_death_mask_energy < death_mask_energy:
		current_death_mask_energy += death_mask_energyregen_speed * _delta
		current_death_mask_energy = min(current_death_mask_energy, death_mask_energy)
		player_light.color = Color.WHITE
		
	
 

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
		
		
func change_music():
	# Lista de todos tus nodos de música
	var music_nodes = [$MusicDeath, $MusicFire, $MusicGravity, $NormalMusic]
	
	# Detenemos todos de forma segura
	for music in music_nodes:
		if music != null: # Esto evita el crash si el nodo no existe
			music.stop()
	
	# Reproducimos la que corresponde
	if current_mask == Global.MASK_DEATH:
		$MusicDeath.play()
	elif current_mask == Global.MASK_FIRE:
		$MusicFire.play()
	elif current_mask == Global.MASK_ANTIGRAVITY:
		$MusicGravity.play()
	else:
		# Si no hay máscara, vuelve la música base
		if $NormalMusic != null:
			$NormalMusic.play()
	
	
	
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
		
	change_music()
	update_animation()
	
func is_on_the_floor():
	if gravity_direction == 1:
		return is_on_floor()
	else:
		return is_on_ceiling()
		
func die() -> void:
	if is_dead:
		return
	is_dead = true
	velocity.x = 0
	update_animation()
	
	$Death.play()
	
	set_physics_process(false)
	player_light.color = Color.GRAY
	await get_tree().create_timer(0.2).timeout
	player_light.color = Color.DIM_GRAY
	await get_tree().create_timer(0.2).timeout
	player_light.color = Color.BLACK
	await get_tree().create_timer(0.2).timeout
	
	Global.die.emit()
	
func touch_water() -> void:
	if current_mask == Global.MASK_FIRE:
		die()
