extends KinematicBody2D
signal shoot(bullet,direction,location)
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var screen_size
export (float) var player_size = 26
# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
export (int) var speed = 200

var raw_velocity = Vector2()
var act_velocity = Vector2()

func get_input():
	raw_velocity = Vector2()
	if Input.is_action_pressed('move_right'):
    	raw_velocity.x += 1
	if Input.is_action_pressed('move_left'):
    	raw_velocity.x -= 1
	if Input.is_action_pressed('move_down'):
    	raw_velocity.y += 1
	if Input.is_action_pressed('move_up'):
    	raw_velocity.y -= 1
	act_velocity = raw_velocity.normalized() * speed
	
	look_at(get_global_mouse_position())
	
	position.x = clamp(position.x, 0+player_size, screen_size.x-player_size)
	position.y = clamp(position.y, 0+player_size, screen_size.y-player_size)

func _physics_process(delta):
	get_input()
	act_velocity = move_and_slide(act_velocity)
	if Input.is_action_pressed("left_click"):
		var bullet_position = Vector2()
		bullet_position = (position) + Vector2(player_size*cos(rotation), player_size*sin(rotation))
		emit_signal("shoot", Bullet, rotation, bullet_position)



var Bullet = preload("res://Bullet.tscn")

	
