extends Control
@onready var file_dialog: FileDialog = $FileDialog

var pic_data
var ssCount = 1
func get_pic():
	pass
	#pick_data = FileDialog.

func _ready() -> void:
	get_tree().get_root().files_dropped.connect(_on_file_drop)
	file_dialog.show()
	var dir = DirAccess.open("user://")
	dir.make_dir("pic")
	dir.make_dir("preview")
	dir.make_dir("resources")

	dir = DirAccess.open("user://preview")
	for n in dir.get_files():
		ssCount += 1

func _on_file_dialog_file_selected(path: String) -> void:
	
	ssCount += 1
	
	var image = Image.new()
	image.load(path)
	#"res://savegame.tres"
	image.shrink_x2()
	
	var res = Note.new()
	res.id = ssCount
	image.save_png("user://pic/pic"+str(ssCount)+".png")
	res.pic = "user://pic/pic"+str(ssCount)+".png"
	
	var image_texture = ImageTexture.new()
	image_texture.set_image(image)
	image.shrink_x2()
	image.save_png("user://preview/pic"+str(ssCount)+".png")
	res.preview_pic = "user://preview/pic"+str(ssCount)+".png"
	$TextureRect.texture = image_texture
	
	ResourceSaver.save(res, "user://resources/note"+str(ssCount)+".tres")
#@export var id : int
#@export var preview_pic : String
#@export var pick : String
#
#@export var data : Array[MarkerData]
#@export var lib : String


func _on_button_pressed() -> void:
	$FileDialog.show()

func _on_file_drop(files):
	_on_file_dialog_file_selected(files[0])
