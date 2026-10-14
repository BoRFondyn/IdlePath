extends ProgressBar

@onready var heart_progress: ProgressBar = $"."
@onready var damage_component: DamageComponent = $"../DamageComponent"

@export var color_full: Color = Color.GREEN
@export var color_empty: Color = Color.RED


func _ready() -> void:
	var style = get_theme_stylebox("fill").duplicate()
	
	add_theme_stylebox_override("fill", style)
	heart_progress.visible = false
	damage_component.health_changed.connect(_on_health_changed)
	
	_on_health_changed(damage_component.current_damage, damage_component.max_damage)


func _process(delta: float) -> void:
	var ration = value / max_value
	
	var current_style = get_theme_stylebox("fill") as StyleBoxFlat
	if current_style:
		current_style.bg_color = color_empty.lerp(color_full, ratio)


func _on_health_changed(current_health: int, max_health: int):
	heart_progress.max_value = max_health
	heart_progress.value = max_health - current_health
