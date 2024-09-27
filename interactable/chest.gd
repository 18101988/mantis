extends StaticBody3D

signal toggle_cursor_interaction(external_inventory_owner)

@export var inventory_data: InventoryData

func player_interact() -> void:
	#print("I am getting goods")
	toggle_cursor_interaction.emit(self)
	
