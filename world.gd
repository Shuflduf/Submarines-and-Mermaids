extends Node2D

@export var placeables: Array[PackedScene]
var current_index = 0
var current_team = "Red"
var paused = false

func _on_ui_changed_selected(index: int) -> void:
	current_index = index

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			var new_placeable = placeables[current_index].instantiate()
			add_child(new_placeable)
			new_placeable.position = get_local_mouse_position()
			if current_team == "Red":
				new_placeable.target_team = &"blue"
				new_placeable.add_to_group(&"red")
				new_placeable.modulate = Color.RED
			elif current_team == "Blue":
				new_placeable.target_team = &"red"
				new_placeable.add_to_group(&"blue")
				new_placeable.modulate = Color.BLUE


func _on_ui_changed_team(team: String) -> void:
	current_team = team


func _on_ui_cleared() -> void:
	for enemy in get_tree().get_nodes_in_group(&"red") + get_tree().get_nodes_in_group(&"blue"):
		enemy.queue_free()


func _on_ui_changed_pause_state(new_paused: bool) -> void:
	paused = new_paused
