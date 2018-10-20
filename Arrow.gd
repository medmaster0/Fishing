extends RigidBody2D

onready var map = get_parent()

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

#Movement variables
var time = 0
var x_pos
var y_pos
var x_pos_init = 0
var y_pos_init = 0
var velocity = Vector2(0,-100) #float upwards DEBUG: right

#Esoteric Variables
var direction_code = 0 #0-3, left, up , right, down

func _ready():
	
	# Called when the node is added to the scene for the first time.
	# Initialization here
	#self.set_modulate(Color(randf(),randf(),randf()))
	$CollisionShape2D.disabled = false
	
	#Direction code and rotation
	direction_code = randi()%4
	match direction_code:
		0:
			rotation = -PI/2
		1:
			pass
		2:
			rotation = PI/2
			x_pos_init = x_pos_init + map.cell_size.x
		3:
			rotation = PI
			x_pos_init = x_pos_init + map.cell_size.x
	
	#Disable any further rotation
	mode = RigidBody2D.MODE_CHARACTER 
	
	pass

func _process(delta):
	# Called every frame. Delta is time since last frame.
	
	time = time + delta
	
	#Calculate position
	x_pos = (velocity.x * time) + x_pos_init
	y_pos = (velocity.y * time) + y_pos_init
	
	#Set position
	#Lock to GRID
	#position = map.map_to_world(map.world_to_map(Vector2(x_pos,y_pos)))
	
	#NOT Lock to GRID
	position = Vector2(x_pos,y_pos)
	
	update()

func _on_Visibility_screen_exited():
	queue_free()