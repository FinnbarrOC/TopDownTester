extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var Enemy1 = preload("res://Enemy1.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("Player").load_game()
	for i in range (10):
		var e = Enemy1.instance()
		add_child(e)
		e.rotation = 0
		e.position = Vector2(500+i,400)
		
	emit_signal("start_timer")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
var can_shoot = false

signal start_timer ()

func _on_Player_shoot(Bullet, direction, location):
	if(can_shoot):
		can_shoot = false
		var b = Bullet.instance()
		add_child(b)
		b.rotation = direction
		b.position = location 
		b.velocity = b.velocity.rotated(direction)
		emit_signal("start_timer")
		self.get_node("Player").bulletcount-=1

func _on_Timer_timeout():
	can_shoot=true
