extends RigidBody2D

signal hit

onready var map = get_parent()
export (int) var min_speed # Minimum speed range.
export (int) var max_speed # Maximum speed range.

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

#Creating projectile motion
var velocity = Vector2(0,0)
var grav =300 #factor of gravity
var time = 0 #total time since launch (in seconds)
var x_pos
var y_pos
var x_pos_init #initial position
var y_pos_init #initial position

#Other variables
var is_caught = false

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	randomize()
	$Prim.set_modulate(Color(randf(),randf(),randf()))
	$Seco.set_modulate(Color(randf(),randf(),randf()))
	$CollisionShape2D.disabled = false

	#Set initial parameters 
	#(Position gets set in calling function
	#But direction and velocity set here
	#FInd a random direction
	var direction = rand_range(-PI/4, PI/4)
	velocity = Vector2(0, -rand_range(min_speed, max_speed)).rotated(direction)
	
	


func _process(delta):
	# Called every frame. Delta is time since last frame.
	# Update game logic here.
	
	if is_caught == true:
		return #and do nothing
	
	
	#Calculate position of fish based on time
	time = time + delta
	
	x_pos = (velocity.x * time) + x_pos_init
	y_pos = (0.5*grav*time*time) + (velocity.y * time) + y_pos_init 
	
	#Lock to GRID
	position = map.map_to_world(map.world_to_map(Vector2(x_pos,y_pos)))
	
	#position = Vector2(x_pos, y_pos)
	
	update()

func _on_Visibility_screen_exited():
	queue_free()
	#pass

func _on_Fish_body_entered(body):
	pass # replace with function body
