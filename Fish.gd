extends RigidBody2D

signal hit

export (int) var min_speed # Minimum speed range.
export (int) var max_speed # Maximum speed range.

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	randomize()
	$Prim.set_modulate(Color(randf(),randf(),randf()))
	$Seco.set_modulate(Color(randf(),randf(),randf()))
	$CollisionShape2D.disabled = false

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_Visibility_screen_exited():
	queue_free()
	#pass