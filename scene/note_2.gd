extends Control

@export var note_data : Note
@export var star_node : PackedScene
@onready var stars: Control = $Stars
@onready var saver_loader: Node = %SaverLoader
@onready var text_edit: TextEdit = $TextEdit

var flag := false
var flag_grab := false

func _ready() -> void:
	saver_loader.load_game()
	text_edit.hide()
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("reload"):
		get_tree().reload_current_scene()
	
	if event is InputEventMouseButton and flag:
		print("step2")
		create_star(event.position)
		saver_loader.save_game()
		flag = false

func create_star(pos):
	print("create star")
	var star = star_node.instantiate()
	star.position = pos
	stars.add_child(star)
	star.line_edit_text_changed.connect(_call_save)
	star.edit_flag_switch()

func _call_save():
	saver_loader.save_game()

func set_img():
	
	var image = Image.new()
	var path : String = note_data.pic
	print("path: ",path)
	image.load(path)
	var image_texture = ImageTexture.new()
	image_texture.set_image(image)
	$TextureRect.texture = image_texture

func _on_marker_btn_pressed() -> void:
	print("flag but")
	flag = true

func _on_grab_btn_pressed() -> void:
	get_tree().call_group("things_to_save", "mass_flag_switch")


func _on_edit_btn_pressed() -> void:
	get_tree().call_group("things_to_save", "mass_edit_flag_switch")


func _on_text_edit_text_changed() -> void:
	_call_save()

func _on_lib_btn_button_down() -> void:
	text_edit.show()

func _on_lib_btn_button_up() -> void:
	text_edit.hide()


func _on_lib_btn_toggled(toggled_on: bool) -> void:
	text_edit.visible = !text_edit.visible
