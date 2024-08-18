@tool
extends EditorPlugin

const BREAK_PERIOD := 500

var int_component: CheckBox
var save_component: CheckBox
var position_component: Label

var _pos := Vector2(0.0, 0.0)
var _is_integer := false
var _is_save := false
var _last_move_time := 0.0
var _last_display_flag := true


func _enter_tree():
	int_component = preload("res://addons/mouse_coordinates/int.tscn").instantiate()
	save_component = preload("res://addons/mouse_coordinates/save.tscn").instantiate()
	position_component = preload("res://addons/mouse_coordinates/position.tscn").instantiate()

	add_control_to_container(CONTAINER_CANVAS_EDITOR_MENU, int_component)
	add_control_to_container(CONTAINER_CANVAS_EDITOR_MENU, save_component)
	add_control_to_container(CONTAINER_CANVAS_EDITOR_MENU, position_component)
	
	int_component.toggled.connect(_on_int_toggled)
	save_component.toggled.connect(_on_save_toggled)


func _exit_tree():
	remove_control_from_container(CONTAINER_CANVAS_EDITOR_MENU, int_component)
	remove_control_from_container(CONTAINER_CANVAS_EDITOR_MENU, position_component)
	
	int_component.queue_free()
	position_component.queue_free()


func _process(_delta) -> void:
	if _is_save and not _last_display_flag and Time.get_ticks_msec() - _last_move_time >= BREAK_PERIOD:
		_update_position_component(_pos)
		_last_display_flag = true
	

func _input(event):
	var scene_root = get_tree().get_edited_scene_root()
	_pos = scene_root.get_global_mouse_position()

	if not _is_save:
		_update_position_component(_pos)
	
	_last_move_time = Time.get_ticks_msec()
	_last_display_flag = false


func _on_int_toggled(status: bool) -> void:
	_is_integer = status

	_update_position_component(_pos)


func _on_save_toggled(status: bool) -> void:
	_is_save = status


func _update_position_component(pos: Vector2) -> void:
	if _is_integer:
		position_component.text = str(Vector2i(int(pos.x), int(pos.y)))
	else:
		position_component.text = str(pos)




