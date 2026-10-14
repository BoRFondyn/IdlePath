extends Button

var current_tool: DataTypes.Tools = DataTypes.Tools.None

func _process(delta: float) -> void:
	ToolManager.tool_selected.connect(on_tool_selected)
	if current_tool == DataTypes.Tools.Axe:
		self.icon.region = Rect2(16, 0, 16, 16)
	else:
		self.icon.region = Rect2(32, 0, 16, 16)


func on_tool_selected(tool: DataTypes.Tools) -> void:
	current_tool = tool


func _on_button_down() -> void:
	var action = InputEventAction.new()
	action.action = "useTool"
	action.pressed = true
	Input.parse_input_event(action)


func _on_button_up() -> void:
	var action = InputEventAction.new()
	action.action = "useTool"
	action.pressed = false
	Input.parse_input_event(action)
