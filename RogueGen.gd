extends Node

# Generate the Datamap
#Returns a 2D array (X,Y) of coordinates to place clouds
#array contains:
# 0 - cloud
# 2 - empty
func GenerateClouds(map_size):
	randomize()
	
#	#INitialize!
#	var map = []
#	var empty_id = 2
#	var cloud_id = 0
	
#	#Populate empty map array
#	for x in range( map_size.x ): 
#		var column = []
#		for y in range(map_size.y):
#			column.append(empty_id)
#		map.append(column)
#
#
	
	#Add a few rows of clouds
	#These are the settings
	var num_clouds = randi()%3+3
	#These are the temp variables
	var cloud_length
	var cloud_x 
	var cloud_y = int(map_size.y/4)
	#Create a list (of dictionaries for each cloud)
	var clouds = []
	
	#For each cloud we need to create...
	for cloud_iter in range( num_clouds ):
		#Roll new cloud params
		cloud_length = randi()%6+10
		cloud_x = randi()%int(2*map_size.x/3)
		#cloud_y = randi()%int(map_size.y/3) + map_size.y/3
		cloud_y = cloud_y + randi()%4 + 2
		#Add that info to the disctionary list
		clouds.append( 
			{
				"length": cloud_length,
				"x": cloud_x,
				"y": cloud_y
			}
		)
	
#	#Set map cells based on clouds
#	for cloud in clouds:
#		#Cycle acrosst length
#		for x_iter in range(cloud.length):
#			map[cloud.x+x_iter][cloud.y] = cloud_id
	
	return clouds
	
	
	
	
	
	
	
	
	