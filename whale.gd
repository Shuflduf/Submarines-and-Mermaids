extends CharacterBody2D

@onready var sprite: Sprite2D = $Sprite2D
@export var target_team: StringName

var health = 500

func _physics_process(_delta: float) -> void:
	if get_parent().paused: return
	
	var closest = closest_enemy()
	if closest:
		look_at(closest.position)
	
		var dist = position.distance_to(closest.position)
		if dist > 300.0:
			velocity = Vector2.RIGHT.rotated(rotation) * 100
		else:
			velocity = Vector2.ZERO
	else:
		velocity = Vector2.ZERO

		
	sprite.flip_v = (rotation > PI / 2.0 or rotation < -PI / 2.0)

	move_and_slide()

func closest_enemy() -> Node2D:
	var closest = null
	var closest_dist = INF
	for enemy in get_tree().get_nodes_in_group(target_team):
		var enemy_dist = self.position.distance_squared_to(enemy.position)
		if enemy_dist < closest_dist:
			closest_dist = enemy_dist
			closest = enemy
	return closest

func damage(amount: int):
	health -= amount
	if health <= 0:
		queue_free()
