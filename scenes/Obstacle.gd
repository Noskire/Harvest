extends StaticBody2D

onready var tilemap: TileMap = get_parent().get_node("TileMap")
onready var sprite: Sprite = get_node("Sprite")
onready var rock_collision: CollisionShape2D = get_node("CollisionRock")
onready var tree_collision: CollisionShape2D = get_node("CollisionTree")

func _ready():
	var pos = get_global_position()
	var map_pos = Vector2(int(pos.x / 32), int(pos.y / 32))
	var cell_id = tilemap.get_cellv(map_pos)
	var cell_name = tilemap.get_tileset().tile_get_name(cell_id)
	#grass farm forest rocky lava snow lake ocean
	if cell_name == "grass":
		sprite.set_frame(0)
		rock_collision.set_disabled(false)
	elif cell_name == "forest":
		sprite.set_frame(1)
		tree_collision.set_disabled(false)
	elif cell_name == "snow":
		sprite.set_frame(2)
		tree_collision.set_disabled(false)
	elif cell_name == "rocky":
		sprite.set_frame(3)
		rock_collision.set_disabled(false)
	elif cell_name == "lava":
		sprite.set_frame(4)
		tree_collision.set_disabled(false)
	else:
		sprite.set_frame(0)
