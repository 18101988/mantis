#player.gd
extends CharacterBody3D

#this is use to signal to toggle_inventor to trigger
signal toggle_cursor_interaction()

@export var inventory_data: InventoryData
@export var equip_inventory_data: InventoryDataEquip

const SPEED = 20.0
const JUMP_VELOCITY = 4.5
 
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var health: int = 5

var look_rot: Vector2

#to turn mouselook on and off
var mouselook: bool = true
var free_mouse_cursor: bool = false

#var free_mouse_cursor: bool = false

@onready var main: Node = $".."
@onready var head: Camera3D = $Camera3D
@onready var interact_ray:RayCast3D = $Camera3D/InteractRay


func _ready():
	PlayerManager.player = self
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)



func _unhandled_input(event):
	
	#print(event)
	
	if event is InputEventMouseMotion:
		
		#here we take the look rot variable, and give it's y and x value the event(the mouse movement)
		#and then make it relative to x and y and mulitply it by 0.2.
		#keep in mind, this is only setting up the variables. this is NOT where movement occurs(if
		# that makes sense).
		look_rot.y -= (event.relative.x * 0.2)
		look_rot.x -= (event.relative.y * 0.2)
		look_rot.x = clamp(look_rot.x, -80, 90) #clamp keeps a value between a min and max value.
	
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
	
	#if you press "tab" it will "emit" the toggle_cursor_interaction signal(sends out the signal)
	if Input.is_action_just_pressed("inventory"):
		if free_mouse_cursor == true:

			free_mouse_cursor = false
			mouselook = true

			toggle_cursor_interaction.emit()
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

			free_mouse_cursor = true
			mouselook = false

			toggle_cursor_interaction.emit()
		
	if Input.is_action_just_pressed("interact"):
		interact()
 
func interact() -> void:
	if interact_ray.is_colliding():
		interact_ray.get_collider().player_interact()


func get_drop_position() -> Vector3:
	var direction = -head.global_transform.basis.z
	return head.global_position + direction

func heal(heal_value: int) -> void:
	health += heal_value

func _physics_process(delta: float) -> void:
	# Add the gravity.
	
	if not is_on_floor():
		velocity.y -= gravity * delta
 
	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
 
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "forward", "back")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
 
	move_and_slide()
	

	
	#this if condition is activated when mouselook is true.
	if mouselook == true:

		var plat_rot = get_platform_angular_velocity()
		look_rot.y += rad_to_deg(plat_rot.y * delta)
		head.rotation_degrees.x = look_rot.x
		rotation_degrees.y = look_rot.y

	#get_tree().change_scene_to_file("res://Interiors/Hotel/hotel_main.tscn")
 # Replace with function body.


func _on_front_door_hotel_enter_body_entered(body):
	print("i have moved")
	#get_tree().change_scene_to_file("res://test_stage.tscn")
	get_tree().change_scene_to_file("res://assets/hotel_interiors_no_extra_3.glb")
	#pass
