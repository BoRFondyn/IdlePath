extends NodeState

@export var player: Player
@export var animated_sprite_2d: AnimatedSprite2D
@export var speed: float = 75.0


func _on_process(_delta: float) -> void:
	pass


func _on_physics_process(_delta: float) -> void:
	var direction = GameInputEvents.movement_input()
	
	if direction != Vector2.ZERO:
		player.player_direction = direction
	
	var angle_direction: float = fposmod(rad_to_deg(player.player_direction.angle()), 360.0)
	
	if angle_direction > 22.5 and angle_direction <= 67.5:
		animated_sprite_2d.play("runSE")
	elif angle_direction > 67.5 and angle_direction <= 112.5:
		animated_sprite_2d.play("runS")
	elif angle_direction > 112.5 and angle_direction <= 157.5:
		animated_sprite_2d.play("runSW")
	elif angle_direction > 157.5 and angle_direction <= 202.5:
		animated_sprite_2d.play("runW")
	elif angle_direction > 202.5 and angle_direction <= 247.5:
		animated_sprite_2d.play("runNW")
	elif angle_direction > 247.5 and angle_direction <= 292.5:
		animated_sprite_2d.play("runN")
	elif angle_direction > 292.5 and angle_direction <= 337.5:
		animated_sprite_2d.play("runNE")
	else:
		animated_sprite_2d.play("runE")
	
	if direction:
		player.velocity = direction * speed
	else:
		player.velocity.x = move_toward(player.velocity.x, 0.0, speed * _delta)
		player.velocity.y = move_toward(player.velocity.y, 0.0, speed * _delta)
		
	player.move_and_slide()


func _on_next_transitions() -> void:
	if !GameInputEvents.is_movement_input():
		transition.emit("Idle")


func _on_enter() -> void:
	pass


func _on_exit() -> void:
	animated_sprite_2d.stop()
