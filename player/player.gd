extends CharacterBody3D

signal toggle_inventory()

@export var inventory_data: InventoryData
@export var equip_inventory_data: InventoryDataEquip

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
 
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var health: int = 5

var look_rot: Vector2

@onready var head: Camera3D = $Camera3D
@onready var interact_ray:RayCast3D = $Camera3D/InteractRay


func _ready():
	PlayerManager.player = self
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event):
	
	var free_mouse_cursor = 0
	
	if event is InputEventMouseMotion and free_mouse_cursor == 0: #this is looking for a mouse moving event as well as if the free_mouse_cursor is false.
		look_rot.y -= (event.relative.x * 0.2)
		look_rot.x -= (event.relative.y * 0.2)
		look_rot.x = clamp(look_rot.x, -80, 90)
	
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
		
	if Input.is_action_just_pressed("inventory"):
		toggle_inventory.emit()
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		free_mouse_cursor = 1
	elif Input.is_action_pressed("inventory") and free_mouse_cursor == 1:
		Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
		free_mouse_cursor = 0
		print(free_mouse_cursor)
		
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
	
	var plat_rot = get_platform_angular_velocity()
	look_rot.y += rad_to_deg(plat_rot.y * delta)
	head.rotation_degrees.x = look_rot.x
	rotation_degrees.y = look_rot.y
