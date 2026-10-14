extends NodeState

@export var player: Player
@export var animated_sprite_2d: AnimatedSprite2D


func _on_process(_delta: float) -> void:
	pass


func _on_physics_process(_delta: float) -> void:
	var angle_direction: float = fposmod(rad_to_deg(player.player_direction.angle()), 360.0)
	
	if angle_direction > 22.5 and angle_direction <= 67.5:
		animated_sprite_2d.play("idleSE")
	elif angle_direction > 67.5 and angle_direction <= 112.5:
		animated_sprite_2d.play("idleS")
	elif angle_direction > 112.5 and angle_direction <= 157.5:
		animated_sprite_2d.play("idleSW")
	elif angle_direction > 157.5 and angle_direction <= 202.5:
		animated_sprite_2d.play("idleW")
	elif angle_direction > 202.5 and angle_direction <= 247.5:
		animated_sprite_2d.play("idleNW")
	elif angle_direction > 247.5 and angle_direction <= 292.5:
		animated_sprite_2d.play("idleN")
	elif angle_direction > 292.5 and angle_direction <= 337.5:
		animated_sprite_2d.play("idleNE")
	else:
		animated_sprite_2d.play("idleE")


func _on_next_transitions() -> void:
	GameInputEvents.movement_input()
	
	if GameInputEvents.is_movement_input():
		transition.emit("Walk")
	
	if player.current_tool == DataTypes.Tools.Axe and GameInputEvents.use_tool():
		transition.emit("Chopping")


func _on_enter() -> void:
	pass


func _on_exit() -> void:
	animated_sprite_2d.stop()
