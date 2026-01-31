extends CharacterBody2D

@export var speed = 300.0
@export var jump_velocity = -450.0


func _physics_process(delta):
	if not is_on_floor():
		velocity.y += Global.gravity * delta 
	

	if is_on_floor() and Input.is_action_just_pressed("JUMP"):
		velocity.y = jump_velocity
		$Jump.play()
	

	var direction = Input.get_axis("LEFT",  "RIGHT") 
	velocity.x = direction * speed
	
	move_and_slide()
	# update_animation()
	

func update_animation():
	if velocity.y != 0:
		$Walking.stop()
		$Animation.play("idle")
		
		if velocity.x != 0:
			$Animation.flip_h = velocity.x < 0
		return
		
	if velocity.x == 0:
		$Walking.stop()
		$Animation.play("idle")
	else:
		$Animation.play("moving")
		$Animation.flip_h = false
		if not $Walking.playing:
			$Walking.play()
		
		$Animation.flip_h = velocity.x < 0
