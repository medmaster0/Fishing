extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

onready var map = get_parent()
var linePressed = false

# Step one cell in a direction
func step( dir ):
#	# Clamp vector to 1 cell in any direction
#	dir.x = clamp( dir.x, -1, 1 )
#	dir.y = clamp( dir.y, -1, 1 )
#

	# Calculate new cprint(new_cell)
	var new_cell = get_map_pos() 
	new_cell = new_cell + dir
	
	#Now actually move

	# Check for valid cell to step to
	if map.is_floor( new_cell ):
		set_map_pos( new_cell )
		print(new_cell)
	
	# Announce when we bump something
	else:
		print( "Ow! You hit a wall!" )

func get_map_pos():
	return map.world_to_map( global_position )

func set_map_pos( cell ):
	print("moved")
	position =  map.map_to_world( cell ) 

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	randomize()
	set_process_input( true )
	$Sprite.set_modulate( Color(randf(),randf(),randf()) )
	$Rod.visible = false
	$Hook.visible = false
	$Hook.set_modulate( Color(randf(), randf(), randf()) )
	$HitBox/CollisionShape2D.disabled = true
	pass

func _process(delta):
	# Called every frame. Delta is time since last frame.
	# Update game logic here.
	pass
	
func _draw():
	if linePressed == true:
		print("drawing line")
		#Figure out where to draw line
		var start_cell = get_map_pos()
		var line_pos = map.map_to_world(start_cell)
		draw_line( Vector2(-13,6), Vector2(-13,160), Color(1,1,1), 2.0)
		$Hook.offset = Vector2(-21,160-16+12)
		$HitBox/CollisionShape2D.position = Vector2( $Hook.offset.x+8 , $Hook.offset.y+8 )
		#draw_line( Vector2(line_pos.x - 13, line_pos.y), Vector2(line_pos.x - 13, line_pos.y), Color(0.0,0.0,0.0), 1.0)

func _input( event ):
	# Input
	var UP = event.is_action_pressed("ui_up")
	var DOWN = event.is_action_pressed("ui_down")
	var LEFT = event.is_action_pressed("ui_left")
	var RIGHT = event.is_action_pressed("ui_right")
	
	# Define a vector to modify
	var new_cell = get_map_pos()

	# Modify new_cell based on actions
	if UP:
		step( Vector2( 0, -1 ) )
	if DOWN:
		step( Vector2( 0, 1 ) )
	if LEFT:
		step( Vector2( -1, 0 ) )
	if RIGHT:
		step( Vector2( 1, 0 ) )
		
	#Debug
	if event is InputEventKey and event.scancode == KEY_L and !event.is_echo() :
		linePressed = true
		$Rod.visible = true
		$Hook.visible = true
		$HitBox/CollisionShape2D.disabled = false
		update()
	if event is InputEventKey and event.scancode == KEY_K and !event.is_echo() :
		linePressed = false
		$Rod.visible = false
		$Hook.visible = false
		$HitBox/CollisionShape2D.disabled = true
		update()
	

func _on_HitBox_body_entered(body):
	print("hit")
	#Stop the body...
	body.linear_velocity = Vector2(0,0)
	
	
