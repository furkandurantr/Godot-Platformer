extends Node2D

const SPEED = 60

var direction = 1

@onready var animated_sprite = $AnimatedSprite2D
@onready var raycast_right = $RaycastRight
@onready var raycast_left = $RaycastLeft

@onready var ray_left = $RayLeft
@onready var ray_right = $RayRight

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if direction == -1 and !ray_left.is_colliding():
		direction = 1
		animated_sprite.flip_h = false
	elif direction == 1 and !ray_right.is_colliding():
		direction = -1
		animated_sprite.flip_h = true
	
	if raycast_right.is_colliding(): 
		direction = -1
		animated_sprite.flip_h = true
	if raycast_left.is_colliding():
		direction = 1
		animated_sprite.flip_h = false
	position.x += direction * SPEED * delta
	
	
