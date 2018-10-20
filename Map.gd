extends TileMap

export (PackedScene) var Arrow
export (PackedScene) var Fish 
export (PackedScene) var Fisherman

#Other variables
var fish_colors
var fish_colors2

var rand_col4

var map_clouds

# Return TRUE if cell is a floor on the map
func is_floor( cell ):
	return get_cellv( cell ) != 1 && get_cellv( cell ) != 0

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	randomize()
	
	#Gen fish colors
	fish_colors = [Color(randf(),randf(),randf()), 
					Color(randf(),randf(),randf()), 
					Color(randf(),randf(),randf())]
	fish_colors2 = [Color(randf(),randf(),randf()), 
					Color(randf(),randf(),randf()),
					Color(randf(),randf(),randf())]
	
	#var screen_size = Vector2(Globals.get("display/width"),Globals.get("display/height"))
	#print(OS.get_real_window_size())
	#Test function gen
	#var data = RogueGen.GenerateClouds(map_to_world(get_viewport().size))
	#get_node("/root/global").goto_scene("res://scene_a.tscn")
	#var data = get_node("/root/RogueGen").GenerateClouds(map_to_world(get_viewport().size))
	#var RogueGen = preload("RogueGen.gd")
	#print("ok")
	var map_size = world_to_map(get_viewport().size)
	map_clouds = RogueGen.GenerateClouds(map_size) #receive coords/info about clouds
	
	#Choose a unique color
	var rand_col = Color(randf(), randf(), randf())
	var rand_col2 = Color(randf(), randf(), randf())
	var rand_col3 = Color(randf(), randf(), randf())
	rand_col4 = Color(randf(), randf(), randf())
	#TileMap.tile_set.set_modulate(0,rand_col)
	self_modulate = rand_col
	
	#go through each cloud and drawwwllll
	for cloud in map_clouds:
		
		#cycle along length and set cells
		for x_iter in range(cloud.length):
			#change the cell
			set_cell(cloud.x + x_iter, cloud.y, 0)
		
		#Also, create a new fisherman there
		var temp_fisherman = Fisherman.instance()
		add_child(temp_fisherman)
		var temp_position = map_to_world(Vector2( (randi()%cloud.length)+cloud.x , cloud.y - 1 ))
		temp_fisherman.position = temp_position
		
		temp_fisherman.get_child(0).set_modulate(rand_col2)
		temp_fisherman.get_child(4).set_modulate(rand_col3)
		
		#AAlso, create a flag in each cloud on whether a fish is caught there
		cloud["fisherman"] = temp_fisherman
	
	#Iterate through map data
#	for x in range(map_data.size()):
#		for y in range(map_data[x].size()):
#			if map_data[x][y] == 0:
#				set_cell(x, y, map_data[x][y])
			
	
	

	
		
	#Draw background
	$CanvasLayer/Background.scale = get_viewport().size
	$CanvasLayer/Background.set_modulate( Color(randf(), randf(), randf()))
	
	#Make arrow
	var arrow = Arrow.instance()
	add_child(arrow)
	var temp_position = Vector2(50,50)
	arrow.position = temp_position

	#Start timers
	$SpawnTimer.start()
	$ArrowTimer.start()
	

func _process(delta):
	# Called every frame. Delta is time since last frame.
	# Update game logic here.
	pass


func _on_SpawnTimer_timeout():
	#Create a fish instance and add to scene
	var fish = Fish.instance()
	add_child(fish)
	$SpawnPath/SpawnLocation.set_offset(randi())
	fish.position = $SpawnPath/SpawnLocation.position
	fish.gravity_scale = 0
	fish.x_pos_init = fish.position.x
	fish.y_pos_init = fish.position.y
	
	var type_index = randi()%fish_colors.size()
	
	fish.get_child(1).set_modulate( fish_colors2[type_index] )
	fish.get_child(2).set_modulate( fish_colors[type_index] )



func _on_ArrowTimer_timeout():
	
	#Cycle through clouds and determine if need to spawn an arrow there
	for cloud in map_clouds:
		if cloud["fisherman"].fishCaught == true:
				#Create an arrow instance and add to scene
				var arrow = Arrow.instance()
				arrow.get_child(0).set_modulate(rand_col4)
				arrow.x_pos_init = 100
				arrow.y_pos_init = 300
				
				
				#$Sprite.global_position.x
				
				arrow.x_pos_init = cloud["fisherman"].get_child(0).global_position.x - (1*cell_size.x)
				arrow.y_pos_init = cloud["fisherman"].get_child(0).global_position.y + (10*cell_size.y)
				
				arrow.position = Vector2(arrow.x_pos_init, arrow.y_pos_init)
				add_child(arrow)
	
#	#Create an arrow instance and add to scene
#	var arrow = Arrow.instance()
#	print(rand_col4)
#	arrow.get_child(0).set_modulate(rand_col4)
#	arrow.x_pos_init = 100
#	arrow.y_pos_init = 100
#	arrow.position = Vector2(arrow.x_pos_init, arrow.y_pos_init)
#	add_child(arrow)
	
	pass # replace with function body





