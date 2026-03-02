extends Area2D

var shooter: Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if get_parent().paused: return
	
	position += Vector2.RIGHT.rotated(rotation) * 1000.0 * delta


func _on_body_entered(body: Node2D) -> void:
	if shooter == body:
		return
	body.damage(30)
	queue_free()


func _on_area_entered(_area: Area2D) -> void:
	queue_free()
