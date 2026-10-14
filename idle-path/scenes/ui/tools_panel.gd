extends PanelContainer

@onready var button_axe: Button = $MarginContainer/HBoxContainer/ButtonAxe
@onready var button_pickaxe: Button = $MarginContainer/HBoxContainer/ButtonPickaxe


func _on_button_axe_pressed() -> void:
	ToolManager.select_tool(DataTypes.Tools.Axe)


func _on_button_pickaxe_pressed() -> void:
	ToolManager.select_tool(DataTypes.Tools.None)
