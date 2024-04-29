extends CharacterBody2D


const SPEED = 130.0
const JUMP_VELOCITY = -300.0
var canjump = true
var wallcling = 0
var walljump = true
var walljampdir = 0
var candash = true

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var wallgravity = ProjectSettings.get_setting("physics/2d/default_gravity")/1.5

@onready var timer = $Timer

@onready var audio_stream_player_2d = $AudioStreamPlayer2D
@onready var audio_stream_player_2d_2 = $AudioStreamPlayer2D2

@onready var animated_sprite = $AnimatedSprite2D

func _physics_process(delta):
	# Add the gravity.
	var direction = Input.get_axis("move_left", "move_right")
	
	if not is_on_floor():
			velocity.y += gravity * delta
			
	if velocity.y >= 0 and is_on_wall_only():
		pass
		#velocity.y -= wallgravity*2 * delta
			
	if is_on_wall_only() and Input.is_action_just_pressed("jump") and walljump:
		velocity.y = JUMP_VELOCITY
		walljump = false
		velocity.x -= direction * SPEED
		candash = false
		walljampdir = direction
		audio_stream_player_2d.play()
	
	if is_on_floor():
		canjump = true
		wallcling = 0
		if candash == false:
			candash = true
			audio_stream_player_2d_2.play()
	
	if Input.is_action_just_pressed("down") and is_on_floor():
		position.y += 1
	
	if not is_on_wall() and Input.is_action_just_pressed("jump") and canjump == false and candash == true and direction != 0:
		candash = false
		velocity.x += direction * (SPEED*2)
		#velocity.y = -100

	if velocity.x >= (SPEED*2) or velocity.x <= -(SPEED*2):
		if velocity.y > 0:
			velocity.y = 0
			pass
	
	# Handle jump.
	if Input.is_action_just_pressed("jump") and canjump:#and is_on_floor():
		canjump = false
		audio_stream_player_2d.play()
		velocity.y = JUMP_VELOCITY
	
	

		
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

	if !is_on_wall_only() and walljump == false and walljampdir != direction:
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
