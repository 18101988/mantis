extends CharacterBody3D

#these variables are for mouselook

#this variable is the speed amount.
@export var speed = 10.0

#this sets the speed of your crouch.
@export var crouch_speed = 1.0

#this variable is how much you accelerate when moving.
@export var accel = 16.0

#this value indicates how high you jump.
@export var jump = 8.0

#this indicates how high you are when you crouch.
@export var crouch_height = 2.4

#how quick the transition between standing and crouch is
@export var crouch_transition = 8.0

@export var sensitivity = 0.2

#angle for min angle before reseting it.
@export var min_angle = -80

#max angle before resetting.
@export var max_angle = 90

#head variable is the object $Head
@onready var head = $Head

#this variable represents the object called CollisionShape3D
@onready var collision_shape = $CollisionShape3D

#this variable is for the TopCast Node3D
#@onready var top_cast = $TopCast

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

#this vaiable holds the vecotrs of 2 points, x and y.(there is no bracket?)
var look_rot : Vector2

#this variable holds a float value of the standing height of the character. We calculate
#its actual value later.
var stand_height : float
#variables for mouselook end here.

#the speed of you
const SPEED = 6.0
const JUMP_VELOCITY = 4.5

#this function is called ready and it will create a state of ready.
func _ready():
	stand_height = collision_shape.shape.height
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta):
	
	var move_speed = speed
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	elif Input.is_action_pressed("crouch"):
		move_speed = crouch_speed
		crouch(delta)
	else:
		crouch(delta, true)
				
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "forward", "backwards")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

	move_and_slide()
	
	var plat_rot = get_platform_angular_velocity()
	look_rot.y += rad_to_deg(plat_rot.y * delta)
	head.rotation_degrees.x = look_rot.x
	rotation_degrees.y = look_rot.y
	
func _input(event):
	if event is InputEventMouseMotion:
		look_rot.y -= (event.relative.x * sensitivity)
		look_rot.x -= (event.relative.y * sensitivity)
		look_rot.x = clamp(look_rot.x, min_angle, max_angle)
	
func crouch(delta : float, reverse = false):
	var target_height : float = crouch_height if not reverse else stand_height
	
	collision_shape.shape.height = lerp(collision_shape.shape.height, target_height, crouch_transition * delta)
	collision_shape.position.y = lerp(collision_shape.position.y, target_height * 0.5, crouch_transition * delta)
	head.position.y = lerp(head.position.y, target_height - 1, crouch_transition * delta)
	
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	
