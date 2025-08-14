@tool
extends ConfirmationDialog

var tilemaplayer:TileMapLayer
#原
@onready var ox: LineEdit = $VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer/LineEdit
@onready var oy: LineEdit = $VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer/LineEdit2
#新
@onready var nx: LineEdit = $VBoxContainer/HBoxContainer/VBoxContainer2/HBoxContainer/LineEdit
@onready var ny: LineEdit = $VBoxContainer/HBoxContainer/VBoxContainer2/HBoxContainer/LineEdit2

@onready var si: LineEdit = $VBoxContainer/VBoxContainer/HBoxContainer/LineEdit
var source_id:int=0

func _ready() -> void:
	popup_centered_ratio(0.3)

	#给ok_button连接pressed信号
	get_ok_button().pressed.connect(_on_ok_pressed)
	#赋初值
	pass


func _on_ok_pressed():
	source_id=int(si.text)
	var origin_tileset_id:Vector2i=Vector2i(int(ox.text),int(oy.text))
	var new_tileset_id:Vector2i=Vector2i(int(nx.text),int(ny.text))
	var used_cells:=tilemaplayer.get_used_cells()
	var origin_coords:PackedVector2Array
	for i in used_cells:
		var tileset_id=tilemaplayer.get_cell_atlas_coords(i)
		if origin_tileset_id==tileset_id:
			origin_coords.append(i)
	for i in origin_coords:
		tilemaplayer.set_cell(i,source_id,new_tileset_id)
	pass
