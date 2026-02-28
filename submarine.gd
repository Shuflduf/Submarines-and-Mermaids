extends CharacterBody2D

func _physics_process(delta: float) -> void:
	var closest = closest_enemy(&"blue")
	if closest:
		look_at(closest.position)
	
	velocity = Vector2.RIGHT.rotated(rotation) * 100

	move_and_slide()

func closest_enemy(team: StringName) -> Node2D:
	var closest = null
	var closest_dist = INF
	for enemy in get_tree().get_nodes_in_group(team):
		var enemy_dist = self.position.distance_squared_to(enemy.position)
		if enemy_dist < closest_dist:
			closest_dist = enemy_dist
			closest = enemy
	return closest
