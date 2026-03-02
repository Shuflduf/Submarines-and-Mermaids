extends CharacterBody2D
@onready var timer: Timer = $Timer

@onready var sprite: Sprite2D = $Sprite2D
@export var target_team: StringName

var health = 50

func _ready() -> void:
	await get_tree().physics_frame
	var closest = closest_enemy()
	if closest:
		var target_dir = position.direction_to(closest.position)
		rotation = atan2(target_dir.y, target_dir.x)


func _physics_process(delta: float) -> void:
	if get_parent().paused: return
	
	var closest = closest_enemy()
	if closest:
		var target_dir = position.direction_to(closest.position)
		var target_rot = atan2(target_dir.y, target_dir.x)
		rotation = lerp_angle(rotation, target_rot, delta)
	
		var dist = position.distance_to(closest.position)
		if dist > 200.0:
			velocity = Vector2.RIGHT.rotated(rotation) * 500
		else:
			velocity = Vector2.ZERO
			if timer.is_stopped() and closest:
				closest.damage(5)
				timer.start()
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
