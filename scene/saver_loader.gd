extends Node
class_name SaverLoader


@onready var stars: Control = $"../Stars"
@onready var texture_rect: TextureRect = %TextureRect

@export var star_node : PackedScene

@onready var note_data = $"..".note_data

func save_game():
	print("saved")
	var saved_note:Note = Note.new()
	var data:Array[StarData] = []
	get_tree().call_group("things_to_save", "on_save_game", data)
	saved_note.data = data
	saved_note.id = note_data.id
	saved_note.preview_pic = note_data.preview_pic
	saved_note.pic = note_data.pic
	saved_note.lib = $"../TextEdit".text
	
	ResourceSaver.save(saved_note, "user://resources/note"+str(note_data.id)+".tres")

func load_game():
	#var saved_note:Note = load("user://resources/note"+str(note_data.id)+".tres")
	
	set_bg_pic(note_data.pic)
	$"../TextEdit".text = note_data.lib
	get_tree().call_group("things_to_save","on_before_load_game")
	
	for item in note_data.data:
		#var scene = load(item.scene_path) as PackedScene
		var restored_node = star_node.instantiate()
		stars.add_child(restored_node)

		if restored_node.has_method("on_load_game"):
			restored_node.on_load_game(item)
		if restored_node.has_signal("line_edit_text_changed"):
			restored_node.line_edit_text_changed.connect(save_game)
		if Globe.show_hide_flag:
			restored_node.hide_all_text()
func set_bg_pic(path):
	var image = Image.new()
	image.load(path)
	var image_texture = ImageTexture.new()
	image_texture.set_image(image)
	texture_rect.texture = image_texture
