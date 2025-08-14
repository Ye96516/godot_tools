@tool
extends EditorPlugin

const REPLACE_DIALOG = preload("res://addons/replace_tiles/replace_dialog.tscn")
var tml:TileMapLayer
var atlas_editor: Control
var map_editor:Control
var button:Button

func _enter_tree() -> void:
	for node in EditorInterface.get_selection().get_selected_nodes():
		if node is TileMapLayer:
			tml = node

	var editor:=get_atlas_source_editor()
	get_tile_map_layer_editor()

	if not editor :
		return
		
	if button != null:
		var container = atlas_editor.get_child(1).get_child(0)

		if container != null:
			container.add_child(gener_button())
	pass

func _exit_tree() -> void:
	if is_instance_valid(button):
		button.queue_free()
	pass

func _handles(object: Object) -> bool:
	return object is TileMapLayer
	
func _edit(object: Object) -> void:
	if not object:
		return
	tml=object as TileMapLayer
	_add_to_tile_set()
	_add_to_tile_map()

func get_atlas_source_editor() -> Node:
	var nodes := [EditorInterface.get_base_control()]
	while nodes:
		var node := nodes.pop_front() as Node
		if node.get_class() == "TileSetAtlasSourceEditor":
			atlas_editor = node
			return node
		nodes.append_array(node.get_children())
	return null

func get_tile_map_layer_editor() -> Node:
	var nodes := [EditorInterface.get_base_control()]
	while nodes:
		var node := nodes.pop_front() as Node
		if node.get_class() == "TileMapLayerEditor":
			map_editor = node
			return node
		nodes.append_array(node.get_children())
	return null

func _add_to_tile_set():
	if  atlas_editor.get_child(1).get_child(0).get_child_count()<=6:
		atlas_editor.get_child(1).get_child(0).add_child(gener_button())

func  _add_to_tile_map():
	if map_editor.get_child(0).get_child(1).get_child_count()<=2:
		map_editor.get_child(0).get_child(1).add_child(gener_button())
	pass
	
func _on_editor_button_node_pressed():
	var replace:=REPLACE_DIALOG.instantiate()
	EditorInterface.get_base_control().add_child(replace)
	replace.tilemaplayer=tml
	pass

func gener_button() -> Button:
	var button_node = Button.new()
	button_node.text = "替换瓦片"
	button_node.pressed.connect(_on_editor_button_node_pressed)
	button=button_node
	return button_node
