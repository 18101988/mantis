extends Node

const PickUp = preload("res://item/pick_up/pick_up.tscn")

@onready var player: CharacterBody3D = $Player
@onready var inventory_interface: Control = $UI/InventoryInterface
@onready var hot_bar_inventory: PanelContainer = $UI/HotBarInventory



func _ready() -> void:
	#the signal that was emited from player.gd will reach this toggle_inventory signal and trigger
	#it to connect to main.gd and fire the function called toggle_inventory_interface
	player.toggle_inventory.connect(toggle_inventory_interface)
	inventory_interface.set_player_inventory_data(player.inventory_data)
	inventory_interface.set_equip_inventory_data(player.equip_inventory_data)
	inventory_interface.force_close.connect(toggle_inventory_interface)
	hot_bar_inventory.set_inventory_data(player.inventory_data)
	
	for node in get_tree().get_nodes_in_group("external_inventory"):
		node.toggle_inventory.connect(toggle_inventory_interface)

#this is the function that is attached to the signal fired by toggle_inventory up in the 
# _ready() funciton
func toggle_inventory_interface(external_inventory_owner = null) -> void:
	#inventory_interface.visible = not inventory_interface.visible
	
	var cursor_visible = 0
	
	#hot_bar_inventory.show()
	inventory_interface.show()
	
	if Input.is_action_just_pressed("inventory") and cursor_visible == 0:
		#pass
		print(" first if %s", cursor_visible)
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		print(Input.mouse_mode)
		cursor_visible = 1
		#hot_bar_inventory.show()
	
	if Input.is_action_just_pressed("inventory") and cursor_visible == 1:
		#pass
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		
		print("second if %s", cursor_visible)
		#hot_bar_inventory.hide()
	
	
	#func toggle_inventory_interface() -> void:
	#
	#inventory_interface.visible = not inventory_interface.visible
	#
	#if inventory_interface.visible:
	#	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	#	#hot_bar_inventory.hide()
	#else:
	#	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	#	hot_bar_inventory.show()
		
	if external_inventory_owner and inventory_interface.visible:
		inventory_interface.set_external_inventory(external_inventory_owner)
	else:
		inventory_interface.clear_external_inventory()


func _on_inventory_interface_drop_slot_data(slot_data) -> void:
	var pick_up = PickUp.instantiate()
	pick_up.slot_data = slot_data
	pick_up.position = player.get_drop_position()
	add_child(pick_up)
	print(pick_up.slot_data)
