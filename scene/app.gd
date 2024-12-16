extends Control

@export var note : PackedScene = preload("res://scene/note.tscn")
@export var app : PackedScene = preload("res://scene/app.tscn")
@export var note2 : PackedScene = preload("res://scene/note_2.tscn")

var counter := 0
@onready var h_box_container: HBoxContainer = $CurrentView/ScrollContainer/VBoxContainer/HBoxContainer


func _ready() -> void:
	get_tree().get_root().files_dropped.connect(_on_file_drop)
	var dir = DirAccess.open("user://")
	dir.make_dir("pic")
	dir.make_dir("preview")
	dir.make_dir("resources")
	fill_gallery()

func _on_texture_button_pressed() -> void:
	switch_scene(note)

func switch_scene(new_scene):
	$CurrentView.remove_child($CurrentView.get_child(0))
	var instance = new_scene.instantiate()
	$CurrentView.add_child(instance)
func switch_scene2(new_scene, id):
	$CurrentView.remove_child($CurrentView.get_child(0))
	var instance = new_scene.instantiate()
	var item_load = ResourceLoader.load("user://resources/note"+str(id)+".tres")
	instance.note_data = item_load
	instance.set_img()
	$CurrentView.add_child(instance)

func _on_home_btn_pressed() -> void:
	print("hi")
	#switch_scene(app)
	get_tree().reload_current_scene()

func fill_gallery():
	var dir = DirAccess.open("user://resources")
	#if dir.dir_exists
	for item in dir.get_files():
		counter += 1
		print(item)
		print(dir.get_files())
		var item_load = ResourceLoader.load("user://resources/"+item)
		var gallery_item = TextureButton.new()
		gallery_item.set_custom_minimum_size(Vector2(100,400))
		#gallery_item.size_flags_horizontal.SIZE_EXPAND
		gallery_item.set_h_size_flags(3)
		gallery_item.set_stretch_mode(6)
		gallery_item.pressed.connect(switch_scene2.bind(note2, item_load.id))
		
		var image = Image.new()
		print(item_load.preview_pic)
		var path : String = item_load.preview_pic
		image.load(path)
		var image_texture = ImageTexture.new()
		image_texture.set_image(image)
		
		gallery_item.texture_normal = image_texture
		
		print( counter % 3)
		if counter % 3 == 0:
			var new_h_box_container = HBoxContainer.new()
			new_h_box_container.add_child(gallery_item)
			$CurrentView/ScrollContainer/VBoxContainer.add_child(new_h_box_container)
			h_box_container = new_h_box_container
		else:
			h_box_container.add_child(gallery_item)
		#h_box_container.add_child(gallery_item)

func _on_show_btn_toggled(toggled_on: bool) -> void:
	Globe.show_hide_flag = toggled_on
	if toggled_on:
		get_tree().call_group("things_to_save", "hide_all_text")
	else:
		get_tree().call_group("things_to_save", "show_all_text")
		
	
func _on_file_drop(files):
	print(files)
