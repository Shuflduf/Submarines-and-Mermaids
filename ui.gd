extends Control

signal changed_selected(index: int)
signal changed_team(team: String)
signal cleared
signal changed_pause_state(paused: bool)

func _on_option_button_item_selected(index: int) -> void:
	changed_selected.emit(index)


func _on_button_pressed() -> void:
	if %Button.text == "Red":
		%Button.text = "Blue"
		changed_team.emit("Blue")
	elif %Button.text == "Blue":
		%Button.text = "Red"
		changed_team.emit("Red")


func _on_clear_pressed() -> void:
	cleared.emit()


func _on_paused_pressed() -> void:
	if %Paused.text == "Pause":
		%Paused.text = "Unpause"
		changed_pause_state.emit(true)
	elif %Paused.text == "Unpause":
		%Paused.text = "Pause"
		changed_pause_state.emit(false)
