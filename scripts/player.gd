extends CharacterBody2D


const SPEED = 130.0
const JUMP_VELOCITY = -300.0
var canjump = true
var walljump = true

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var wallgravity = ProjectSettings.get_setting("physics/2d/default_gravity")/1.5

@onready var audio_stream_player_2d = $AudioStreamPlayer2D
@onready var audio_stream_player_2d_2 = $AudioStreamPlayer2D2

@onready var animated_sprite = $AnimatedSprite2D

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
			velocity.y += gravity * delta
	if velocity.y >= 0 and is_on_wall_only():
		pass
		#velocity.y -= wallgravity * delta
			
	if is_on_wall_only() and Input.is_action_just_pressed("jump") and walljump:
		velocity.y = JUMP_VELOCITY
		walljump = false
		audio_stream_player_2d.play()
		


	if is_on_floor():
		canjump = true
	
	# Handle jump.
	if Input.is_action_just_pressed("jump") and canjump:#and is_on_floor():
		canjump = false
		audio_stream_player_2d.play()
		velocity.y = JUMP_VELOCITY
	
	var direction = Input.get_axis("move_left", "move_right")
	
	if Input.is_action_just_pressed("jump"):
		#velocity.x += direction * SPEED*2
		pass
		if velocity.y > 0:
			#velocity.y = 0
			pass
		
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true
	
	if is_on_floor():
		if direction == 0:
			animated_sprite.play("idle")
		else:
			animated_sprite.play("run")
	else:
		animated_sprite.play("jump")

	if !is_on_wall_only() and walljump == false:
		walljump = true
		audio_stream_player_2d_2.play()
	
	if is_on_floor():
		if direction:
			velocity.x = lerp(velocity.x,  direction * SPEED, delta * 8.0)#direction * SPEED
		else:
			velocity.x = lerp(velocity.x,  direction * SPEED, delta * 7.0)#0#move_toward(velocity.x, 0, SPEED)
	else:
		velocity.x = lerp(velocity.x,  direction * SPEED, delta * 4.0)

	move_and_slide()
