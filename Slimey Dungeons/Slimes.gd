extends Spatial


# Declare member variables here. Examples:
var mouse_sensitivity = 0.1


onready var selected_slime = get_node("Initial Slime")
onready var camera_manager = get_node("../Camera Manager")

var inventory = []


class InventoryItem:
	var scene_source : String
	var id : String
	
	func _init(scene_source, id):
		self.scene_source = scene_source
		self.id = id


# Called when the node enters the scene tree for the first time.
func _ready():
	set_as_toplevel(true)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	focus_slime(selected_slime)
	selected_slime.get_node("CollisionShape").disabled = false


func focus_slime(slime):
	slime.collision_layer = pow(2, 0) + pow(2, 15)
	selected_slime = slime
	slime.collision_layer = pow(2, 0)
	camera_manager.scale.z = slime.size
	camera_manager.rotation_degrees.y = selected_slime.rotation_degrees.y
	camera_manager.get_node("HUD/Size Label").text = "Size: " + str(slime.size)


func add_to_inventory(inventory_item):
	inventory.append(inventory_item)
	var inventory_display = camera_manager.get_node("HUD/InventoryDisplay")
	var item_container = inventory_display.get_node("Sample Item").duplicate()
	var item_src = load(inventory_item.scene_source)
	var item = item_src.instance()
	item.name = inventory_item.id
	inventory_display.add_child(item_container)
	item_container.get_node("Viewport").add_child(item)
	item.set_layer_mask(512)
	item_container.visible = true


func is_in_inventory(id):
	for item in inventory:
		if item.id == id:
			return true
	return false


func remove_from_inventory(id):
	var index = 0
	for item in inventory:
		if item.id == id:
			break
		index += 1
	
	inventory.pop_at(index)
	var inventory_display = camera_manager.get_node("HUD/InventoryDisplay")
	inventory_display.get_children().remove(index)

func show_actionbar(text):
	get_node("../Camera Manager/HUD/ActionBar").text = text


func hide_actionbar(text):
	if get_node("../Camera Manager/HUD/ActionBar").text == text:
		get_node("../Camera Manager/HUD/ActionBar").text = ""


func level_complete():
	var level_end_display = get_node("../Camera Manager/HUD/Level End Display")
	if get_node("../Camera Manager").current_level == 15:
		level_end_display.get_node("VBoxContainer/Next Level Container").visible = false
	level_end_display.visible = true
	level_end_display.get_node("VBoxContainer/Label Container/Label").text = "Level Complete!"
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func get_focused():
	return selected_slime


func get_key():
	add_to_inventory(InventoryItem.new("Props/Key.tscn", "key"))


func _unhandled_input(event : InputEvent) -> void:
	if Input.is_action_just_pressed("gameplay_switch"):
		focus_slime(get_child(wrapi(selected_slime.get_index() + 1, 0, get_child_count())))
	if Input.is_action_just_pressed("gameplay_switch_inverse"):
		print(posmod(selected_slime.get_index() - 2, get_child_count()))
		focus_slime(get_child(posmod(selected_slime.get_index() - 2, get_child_count())))
		
	if Input.is_action_just_released("control_lookaround"):
		camera_manager.rotation_degrees.y = selected_slime.rotation_degrees.y
	if event is InputEventMouseMotion:
		camera_manager.rotation_degrees.x -= event.relative.y * mouse_sensitivity
		camera_manager.rotation_degrees.x = clamp(camera_manager.rotation_degrees.x, -90.0, 30)
		
		if !Input.is_action_pressed("control_lookaround"):
			selected_slime.rotation_degrees.y -= event.relative.x * mouse_sensitivity
			selected_slime.rotation_degrees.y = wrapf(selected_slime.rotation_degrees.y, 0.0, 360.0)
		camera_manager.rotation_degrees.y -= event.relative.x * mouse_sensitivity
		camera_manager.rotation_degrees.y = wrapf(camera_manager.rotation_degrees.y, 0.0, 360.0)

