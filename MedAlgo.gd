extends Node

#Caclulate the "opposite color"
#This is the color with each of it's rgb channels 128 (or 0.5) away from the color
#ex. (255,108,176) and (128,236,48)
func oppositeColor(in_col):
	
	var r = in_col.r + 0.5
	if r > 1:
		r = r - 1
	var g = in_col.g + 0.5
	if g > 1:
		g = g - 1
	var b = in_col.b + 0.5
	if b > 1:
		b = b - 1
	
	var out_col = Color(r,g,b)
	return out_col
	
	
#Determine which color will better contrast input color:
#Black or White?	
func contrastColor(in_col):
	
	var in_brightness_count = 0 #this will keep track of which channels are bright (over 0.5)
	if in_col.r > 0.5:
		in_brightness_count = in_brightness_count + 1
	if in_col.g > 0.5:
		in_brightness_count = in_brightness_count + 1
	if in_col.b > 0.5:
		in_brightness_count = in_brightness_count + 1
		
	#If the majority of channels are bright, return black (for contrast)
	if in_brightness_count >=2:
		return(Color(0,0,0))
	#Otherwise return white
	else: 
		return(Color(1,1,1))
	
	
	