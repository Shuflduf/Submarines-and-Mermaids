extends CharacterBody2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var timer: Timer = $Timer
@export var target_team: StringName
@export var torpedo_scene: PackedScene

var health = 100

func _ready() -> void:
	await get_tree().physics_frame
	var closest = closest_enemy()
	if closest:
		var target_dir = position.direction_to(closest.position)
		rotation = atan2(target_dir.y, target_dir.x)


func _physics_process(delta: float) -> void:
	sprite.flip_v = (rotation > PI / 2.0 or rotation < -PI / 2.0)

	if get_parent().paused: return
	
	var closest = closest_enemy()
	if closest:
		var target_dir = position.direction_to(closest.position)
		var target_rot = atan2(target_dir.y, target_dir.x)
		rotation = lerp_angle(rotation, target_rot, delta * 0.5)
	
		var dist = position.distance_to(closest.position)
		if dist > 2000.0:
			velocity = Vector2.RIGHT.rotated(rotation) * 200
		elif dist < 800.0:
			velocity = Vector2.RIGHT.rotated(rotation) * -100
		else:
			velocity = Vector2.ZERO
			if timer.is_stopped():
				var new_torpedo = torpedo_scene.instantiate()
				new_torpedo.position = position
				new_torpedo.rotation = rotation
				new_torpedo.shooter = self
				get_parent().add_child(new_torpedo)
				timer.start()
	else:
		velocity = Vector2.ZERO
		

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
