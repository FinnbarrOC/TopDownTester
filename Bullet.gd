extends KinematicBody2D
signal killEnemy1()
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
export (int) var bullet_speed = 1000

var velocity = Vector2(bullet_speed,0)

func _physics_process(delta):
	var collision = move_and_collide(velocity * delta)
	if collision:
		if collision.collider.has_method("bullet_hit"):
			collision.collider.bullet_hit()
		self.queue_free()