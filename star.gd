extends TextureButton

signal line_edit_text_changed

var mass_flag := false
var flag_grab := false

var mass_edit_flag := false
var edit_flag := false

@onready var line: LineEdit = $Line
var text : String = "Placeholder"

func _ready() -> void:
	$Label.text = text
	line.text = text

#func change_text(new_text):
	#pass

func on_save_game(data:Array[StarData]):
	
	var my_data = StarData.new()
	my_data.pos = global_position
	my_data.text = text 
	data.append(my_data)
#
func on_before_load_game():
	get_parent().remove_child(self)
	queue_free()
#
func on_load_game(saved_data:StarData):
	global_position = saved_data.pos
	text = saved_data.text

func _on_text_changed(new_text: String) -> void:
	text = new_text
	$Label.text = new_text
	line_edit_text_changed.emit()


func _on_texture_button_button_down() -> void:
	flag_grab = true


func _on_texture_button_button_up() -> void:
	flag_grab = false
	if mass_flag:
		line_edit_text_changed.emit()

func _on_texture_button_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and flag_grab and mass_flag:
		global_position = event.global_position
	if event is InputEventMouseButton and !event.is_pressed() and flag_grab and mass_flag:
		check_near_bean(global_position)
		check_pos(global_position)
		line_edit_text_changed.emit()

func mass_flag_switch():
	mass_flag = !mass_flag

func mass_edit_flag_switch():
	mass_edit_flag = !mass_edit_flag
	if not mass_edit_flag and not edit_flag:
		edit_flag = false
		edit_flag_switch()
	else:
		edit_flag_switch()

func edit_flag_switch():
	edit_flag = !edit_flag
	if edit_flag:
		line.editable = true
		$Label.hide()
	else :
		line.editable = false
		$Label.show()
		
func hide_all_text():
	line.hide()
	$Label.hide()

func show_all_text():
	line.show()
	$Label.show()

func check_near_bean(pos):
	if pos.distance_to(Vector2(924,1764)) < 50:
		queue_free()
		line_edit_text_changed.emit()

func check_pos(pos):
	if pos.x > 810:
		line.global_position.x = pos.x - 100
		$Label.global_position.x = pos.x - 100
	if pos.x < 810:
		line.global_position.x = pos.x + 61
		$Label.global_position.x = pos.x + 61
