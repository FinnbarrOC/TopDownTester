extends KinematicBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func bullet_hit():
	self.queue_free() 

var velocity = Vector2()

export (int) var speed = 100

func _physics_process(delta):
	velocity= get_parent().get_node("Player").get_pos() - position
	velocity = velocity.normalized() * speed
	var collision = move_and_collide(velocity *delta)
	if collision:
		velocity = velocity.slide(collision.normal) 
		move_and_collide(velocity*delta)
		if collision.collider.has_method("enemy_hit"):
			collision.collider.enemy_hit(1)
		

