extends CollisionShape3D

const HOTEL_MAIN = preload("res://Interiors/Hotel/hotel_main.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	#if collision_shape_3d.position.x and collision_shape_3d.position.y == entrance_zone.position.x and entrance_zone.position.y: 
		#pass
		#get_tree().change_scene_to_file(HOTEL_MAIN)
		#player.position.x = hotel_entrance
