extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

export (PackedScene) var Arrow
export (PackedScene) var Fish

onready var map = get_parent()
var linePressed = false
var fishCaught = false

#Esoteric Variables
var arrow_direction_code = 1 #0-3, left, up , right, down
var line_length = 10 #How far down the line is (as hook/fish are reeled in)
var hooked_fish #will point to the fish that was hooked

#Changes the direction of the arrow according to above code
func change_arrow_direction(direction_code):
	match direction_code:
		0:
			arrow_direction_code = 0
			$ArrowSprite.rotation = -PI/2
			#snap back to grid
			$ArrowSprite.position.x = - (2*map.cell_size.x)
			$ArrowSprite.position.y = - (1*map.cell_size.y)
		1:
			arrow_direction_code = 1
			$ArrowSprite.rotation = 0
			#snap back to grid
			$ArrowSprite.position.x = 0
			$ArrowSprite.position.y = 0
		2:
			arrow_direction_code = 2
			$ArrowSprite.rotation = PI/2
			#snap back to grid
			$ArrowSprite.position.x = - (1*map.cell_size.x)
			$ArrowSprite.position.y = (2*map.cell_size.y)
		3:
			arrow_direction_code = 3
			$ArrowSprite.rotation = PI
			#snap back to grid
			$ArrowSprite.position.x = - (3*map.cell_size.x)
			$ArrowSprite.position.y = (1*map.cell_size.y)
	

# Step one cell in a direction
func step( dir ):
#	# Clamp vector to 1 cell in any direction
#	dir.x = clamp( dir.x, -1, 1 )
#	dir.y = clamp( dir.y, -1, 1 )
#
	#Don't move if fish is caught
	if fishCaught == true:
		return

	# Calculate new 
	var new_cell = get_map_pos() 
	new_cell = new_cell + dir
	
	#Now actually move
	
	#Check if adjacent tile is on top of a cloud...
	if map.is_floor( Vector2(new_cell.x, new_cell.y + 1) ) == true:
		return #move if not on top of cloud

	# Check for valid cell to step to
	if map.is_floor( new_cell ):
		set_map_pos( new_cell )
		
	
	# Announce when we bump something
	else:
		print( "Ow! You hit a wall!" )

func get_map_pos():
	return map.world_to_map( global_position )

func set_map_pos( cell ):
	position =  map.map_to_world( cell ) 

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	randomize()
	set_process_input( true )
	#$Sprite.set_modulate( Color(randf(),randf(),randf()) )
	$Rod.visible = false
	$Hook.visible = false
	$Hook.set_modulate( Color(randf(),randf(),randf()) )
	$HitBox/CollisionShape2D.disabled = true
	$ArrowHitBox.position.x = (map.cell_size.x)
	$ArrowHitBox/CollisionShape2D.disabled = true
	pass

func _process(delta):
	# Called every frame. Delta is time since last frame.
	# Update game logic here.
	pass
	
func _draw():
	if linePressed == true:
		#Figure out where to draw line
		var start_cell = get_map_pos()
		var line_pos = map.map_to_world(start_cell)
		draw_line( Vector2(-13,6), Vector2(-13,map.cell_size.y*line_length), Color(1,1,1), 2.0)
		$Hook.offset = Vector2(-21,(line_length*map.cell_size.y)-16+12)
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
#	if UP:
#		step( Vector2( 0, -1 ) )
#	if DOWN:
#		step( Vector2( 0, 1 ) )
	if LEFT:
		step( Vector2( -1, 0 ) )
	if RIGHT:
		step( Vector2( 1, 0 ) )
		
	#Debug
	if event is InputEventKey and event.scancode == KEY_L and !event.is_echo() :
		linePressed = true
		$Rod.visible = true
		$Hook.visible = true
		if fishCaught == false:
			$HitBox/CollisionShape2D.disabled = false
		update()
	if event is InputEventKey and event.scancode == KEY_K and !event.is_echo() :
		if fishCaught == true:
			return
		linePressed = false
		$Rod.visible = false
		$Hook.visible = false
		$HitBox/CollisionShape2D.disabled = true
		update()
		
	if event is InputEventKey and event.scancode == KEY_A and !event.is_echo() :
		change_arrow_direction(0) #left
	if event is InputEventKey and event.scancode == KEY_W and !event.is_echo() :
		change_arrow_direction(1) #up
	if event is InputEventKey and event.scancode == KEY_D and !event.is_echo() :
		change_arrow_direction(2) #up
	if event is InputEventKey and event.scancode == KEY_S and !event.is_echo() :
		change_arrow_direction(3) #up
			
	

func _on_HitBox_body_entered(body):
	print("catch fish ")
	#But pass arrows...
	if body.get_filename() == Arrow.get_path():
		return
		
	#If the fish was already caught ignore it
	if body.grav == 0:
		return
	
	#Stop the body...
	#body.is_caught = true
	body.velocity = Vector2(0,0)
	body.grav = 0
	
	body.x_pos_init = $Sprite.global_position.x - map.cell_size.x
	body.y_pos_init = $Sprite.global_position.y + ( (line_length+1)*map.cell_size.y)
	
	#reposition on top of hook
	#print(body.global_position)
	#body.position = map.map_to_world(map.world_to_map(get_child(4).global_position))
	#body.global_position = $Sprite.global_position
	body.update()
	#body.set_map_position(map.map_to_world(map.world_to_map(get_child(4).global_position)))
	
	#Turn off colision
	$HitBox/CollisionShape2D.disabled = true
	#Let other functions know we caught fish
	fishCaught = true
	
	#Turn on Arrow Hitbox...
	$ArrowHitBox/CollisionShape2D.disabled = false
	
	#REcord fish in variable
	hooked_fish = body
	

#Detect if incoming arrow matches fisherman's arrow
func _on_ArrowHitBox_body_entered(body):
		#....But pass fishes
	if body.get_filename() == Fish.get_path():
		return
		
	#Also need to pass hook....
	
	#Also need to skip if we've already processed
	if body.is_processed == true:
		return
	
	#Check if the arrow code matches the fisherman's direction code
	if body.direction_code == arrow_direction_code:
		body.is_processed = true
		body.queue_free()
		#Also need to move the hook and stuff up
		line_length = line_length - 1
		
		#Means we reeled in fish!
		if line_length == -1:
			#Need to update Map Score
			map.fish_scores[hooked_fish.type_id]=map.fish_scores[hooked_fish.type_id] + 1
			
			#Reset rod
			line_length = 10
			hooked_fish.queue_free()
			fishCaught = false
			$ArrowHitBox/CollisionShape2D.disabled = true
			$HitBox/CollisionShape2D.disabled = false
			$Hook.offset.y = 10*map.cell_size.y
			update()
			return
			
		
		#$Hook.position.y = $Hook.position.y - map.cell_size.y
		#hooked_fish.position.y = hooked_fish.position.y - map.cell_size.y
		#hooked_fish.position = Vector2(hooked_fish.position.x, hooked_fish.position.y - map.cell_size.y)
		hooked_fish.y_pos_init = hooked_fish.y_pos_init - map.cell_size.y
		hooked_fish.update()
		
		update()

#Detect if incoming arrow matches fisherman's arrow
func _on_ArrowHitBox_body_exited(body):
	#....But pass fishes
	if body.get_filename() == Fish.get_path():
		return
		
	#Also need to pass hook....
	
		#Also need to skip if we've already processed
	if body.is_processed == true:
		return
	
	#Check if the arrow code matches the fisherman's direction code
	if body.direction_code == arrow_direction_code:
		body.is_processed = true
		body.queue_free()
		#Also need to move the hook and stuff up
		line_length = line_length - 1
		
		#Means we reeled in fish!
		if line_length == -1:
			#Need to update Map Score
			map.fish_scores[hooked_fish.type_id]=map.fish_scores[hooked_fish.type_id] + 1
			
			#Reset rod
			line_length = 10
			hooked_fish.queue_free()
			fishCaught = false
			$ArrowHitBox/CollisionShape2D.disabled = true
			$HitBox/CollisionShape2D.disabled = false
			$Hook.offset.y = 10*map.cell_size.y
			update()
			return
			
		
		#$Hook.position.y = $Hook.position.y - map.cell_size.y
		#hooked_fish.position.y = hooked_fish.position.y - map.cell_size.y
		#hooked_fish.position = Vector2(hooked_fish.position.x, hooked_fish.position.y - map.cell_size.y)
		hooked_fish.y_pos_init = hooked_fish.y_pos_init - map.cell_size.y
		hooked_fish.update()
		
		update()
