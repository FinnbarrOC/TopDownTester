extends KinematicBody2D
signal shoot(bullet,direction,location)
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var inv_timer = 0
var health = 100
var points = 0
var bulletcount= 1000
var screen_size
export (float) var player_size = 26
# Called when the node enters the scene tree for the first time.
func _ready():
	load_game()
	save_game()
	screen_size = get_viewport_rect().size
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
export (int) var speed = 200
var Bullet = preload("res://Bullet.tscn")
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
	if Input.is_action_pressed("sprint"):
		act_velocity *= 2
	
	look_at(get_global_mouse_position())


func _physics_process(delta):
	inv_timer-=delta
	get_input()
	var collision = move_and_collide(act_velocity * delta)
	if collision:
		act_velocity = act_velocity.slide(collision.normal)
		move_and_collide(act_velocity*delta)
	if Input.is_action_pressed("left_click"):
		var bullet_position = Vector2()
		bullet_position = (position) + Vector2(player_size*cos(rotation), player_size*sin(rotation))
		emit_signal("shoot", Bullet, rotation, bullet_position)
	var temp = true
	for i in range (get_parent().get_child_count()):
		if "Enemy" in get_parent().get_child(i).get_name():
			temp = false
	if temp:
		win()
	reset_labels()


func reset_labels():
	get_node("HUD").set_rotation(-rotation)
	get_node("HUD/BulletCounter").text = "Bullets: " + String(bulletcount)
	get_node("HUD/HealthCounter").text = "Health: " + String(health)
	get_node("HUD/Points").text = "Points: " + String(points)
	

func enemy_hit(damage):
	if(inv_timer<=0):
		health-=damage
	if health<=0:
		lose()

func lose():
	health=100
	bulletcount=100
	points = 0
	save_game()
	get_tree().quit()


func win():
	points+=1
	save_game()
	get_tree().quit()

func get_pos():
	return position



func save():
	var save_dict = {
		"filename" : get_filename(),
		"parent" : get_parent().get_path(),
		"pos_x" : position.x, # Vector2 is not supported by JSON
		"pos_y" : position.y,
		"points" : points,
		"health" : health,
		"bulletcount" : bulletcount
	}
	return save_dict

func save_game():
	var save_game = File.new()
	save_game.open("user://savegame.save", File.WRITE)
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	for i in save_nodes:
		var node_data = i.call("save");
		save_game.store_line(to_json(node_data))
	save_game.close()

func load_game():
	var save_game = File.new()
	if not save_game.file_exists("user://savegame.save"):
		return # Error! We don't have a save to load.

	# We need to revert the game state so we're not cloning objects
	# during loading. This will vary wildly depending on the needs of a
	# project, so take care with this step.
	# For our example, we will accomplish this by deleting saveable objects.
   # var save_nodes = get_tree().get_nodes_in_group("Persist")
	#for i in save_nodes:
	 #   i.queue_free()

	# Load the file line by line and process that dictionary to restore
	# the object it represents.
	save_game.open("user://savegame.save", File.READ)
	while not save_game.eof_reached():
		var current_line = parse_json(save_game.get_line())
		# Firstly, we need to create the object and add it to the tree and set its position.
		#var new_object = load(current_line["filename"]).instance()
		#get_node(current_line["parent"]).add_child(new_object)
		#new_object.position = Vector2(current_line["pos_x"], current_line["pos_y"])
		# Now we set the remaining variables.
		if not current_line==null:
			for i in current_line.keys():
				if i == "filename" or i == "parent" or i == "pos_x" or i == "pos_y":
					continue
				self.set(i, current_line[i])
	save_game.close()