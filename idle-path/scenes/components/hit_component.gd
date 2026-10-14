class_name HitComponent

extends Area2D

@export var current_tool: DataTypes.Tools = DataTypes.Tools.None
@export var hit_damage: int = 1

func _process(delta: float) -> void:
	ToolManager.tool_selected.connect(on_tool_selected)
	
	if current_tool == DataTypes.Tools.Axe:
		hit_damage = 2
	else:
		hit_damage = 1


func on_tool_selected(tool: DataTypes.Tools) -> void:
	current_tool = tool
