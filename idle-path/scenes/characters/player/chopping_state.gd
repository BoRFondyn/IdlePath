extends NodeState

@export var player: Player
@export var animated_sprite_2d: AnimatedSprite2D
@export var hit_component_collision_shape: CollisionShape2D


func _ready() -> void:
	hit_component_collision_shape.disabled = true
	hit_component_collision_shape.position = Vector2(0, 0)


func _on_process(_delta: float) -> void:
	pass


func _on_physics_process(_delta: float) -> void:
	pass


func _on_next_transitions() -> void:
	if !animated_sprite_2d.is_playing():
		transition.emit("Idle")


func _on_enter() -> void:
	var angle_direction: float = fposmod(rad_to_deg(player.player_direction.angle()), 360.0)
	
	#replace idle animation for chopping animation
	
	if angle_direction > 22.5 and angle_direction <= 67.5:
		animated_sprite_2d.play("choppingS")
		hit_component_collision_shape.position = Vector2(-3, -5)
	elif angle_direction > 67.5 and angle_direction <= 112.5:
		animated_sprite_2d.play("choppingS")
		hit_component_collision_shape.position = Vector2(-3, -5)
	elif angle_direction > 112.5 and angle_direction <= 157.5:
		animated_sprite_2d.play("choppingS")
		hit_component_collision_shape.position = Vector2(-3, -5)
	elif angle_direction > 157.5 and angle_direction <= 202.5:
		animated_sprite_2d.play("choppingW")
		hit_component_collision_shape.position = Vector2(-9, -8)
	elif angle_direction > 202.5 and angle_direction <= 247.5:
		animated_sprite_2d.play("choppingN")
		hit_component_collision_shape.position = Vector2(-3, -27)
	elif angle_direction > 247.5 and angle_direction <= 292.5:
		animated_sprite_2d.play("choppingN")
		hit_component_collision_shape.position = Vector2(-3, -27)
	elif angle_direction > 292.5 and angle_direction <= 337.5:
		animated_sprite_2d.play("choppingN")
		hit_component_collision_shape.position = Vector2(-3, -27)
	else:
		animated_sprite_2d.play("choppingE")
		hit_component_collision_shape.position = Vector2(9, -8)
	
	hit_component_collision_shape.disabled = false


func _on_exit() -> void:
	animated_sprite_2d.stop()
	hit_component_collision_shape.disabled = true
