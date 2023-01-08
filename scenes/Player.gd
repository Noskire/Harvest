extends KinematicBody2D

onready var tilemap: TileMap = get_parent().get_node("TileMap")
onready var sprite: Sprite = get_node("Sprite")
onready var collision: CollisionShape2D = get_node("Collision")
onready var anim: AnimationPlayer = get_node("AnimationPlayer")
onready var camera: Camera2D = get_node("Camera2D")
onready var hud: Control = get_node("CanvasLayer/HUD")
onready var hud_grid: Control = get_node("CanvasLayer/HUD/PanelContainer/Panel/GridContainer")
onready var map: TextureRect = get_node("CanvasLayer/Map")
onready var player_pos: TextureRect = get_node("CanvasLayer/Map/PlayerPos")
onready var sfx: AudioStreamPlayer = get_node("SFX")

const get_mission_sfx = preload("res://assets/get_mission.mp3")
const complete_mission_sfx = preload("res://assets/complete_mission.mp3")
const take_item_sfx = preload("res://assets/take_item.wav")

export var player_speed = 100.0

var velocity

var types_of_items = 15
var inventory = []
var items_on_range = []

var house
var house_on_range = false

var terrain = ""

func _ready():
	for i in types_of_items:
		inventory.push_back(0)

func _physics_process(_delta: float) -> void:
	# Get direction and move
	velocity = get_direction() * player_speed
	velocity = move_and_slide(velocity)
	
	# Acess house or Harvest
	if Input.is_action_just_pressed("action"):
		if house_on_range:
			house.home(self)
		elif not items_on_range.empty():
			var item = items_on_range[0].harvest()
			if item >= 0:
				inventory[item] += 1
				Stats.items_colleted += 1
				play_sfx(3)
				hud_grid.get_node("Qtd" + str(item + 1)).set_text(str(inventory[item]))
				
				if house != null:
					if house.on_mission:
						house.update_RTLabel(self)
	
	# Menu
	if Input.is_action_just_pressed("menu"):
		hud.set_visible(true)
		map.set_visible(true)
	if Input.is_action_just_released("menu"):
		hud.set_visible(false)
		map.set_visible(false)
	
	# Get in which area the player is
	var pos = get_global_position()
	var map_pos = Vector2(int(pos.x / 32), int(pos.y / 32))
	var cell_id = tilemap.get_cellv(map_pos)
	var cell_name = tilemap.get_tileset().tile_get_name(cell_id)
	if terrain != cell_name:
		terrain = cell_name
	
	# Update player on map
	map_pos = map_pos - Vector2(1, 1)
	map_pos = map_pos * 5
	map_pos.y += 50
	player_pos.set_position(map_pos)

func get_direction() -> Vector2:
	# Get player input
	var direction = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	)
	
	# The direction to where the player will look
	if direction.x > 0:
		sprite.frame_coords.y = 3
	elif direction.x < 0:
		sprite.frame_coords.y = 2
	elif direction.y < 0:
		sprite.frame_coords.y = 1
	elif direction.y > 0:
		sprite.frame_coords.y = 0
	
	if abs(direction.x) > 0 or abs(direction.y) > 0:
		anim.play("Walking")
	else:
		anim.play("Idle")
	return direction.normalized()

func update_grid():
	for i in types_of_items:
		hud_grid.get_node("Qtd" + str(i + 1)).set_text(str(inventory[i]))

func play_sfx(audio_id):
	if(audio_id == 1):
		sfx.set_stream(get_mission_sfx)
	elif(audio_id == 2):
		sfx.set_stream(complete_mission_sfx)
	elif(audio_id == 3):
		sfx.set_stream(take_item_sfx)
	sfx.play()

func _on_HarvestArea_entered(area):
	items_on_range.push_back(area)
	area.outline.set_visible(true)

func _on_HarvestArea_exited(area):
	var pos = items_on_range.find(area)
	if pos >= 0:
		items_on_range.remove(pos)
	area.outline.set_visible(false)

func _on_HouseArea_entered(area):
	house = area.get_parent()
	house_on_range = true
	house.outline.set_visible(true)

func _on_HouseArea_exited(_area):
	house_on_range = false
	house.outline.set_visible(false)

func _on_SFX_finished():
	sfx.stop()
