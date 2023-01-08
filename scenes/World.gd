extends Node2D

onready var tilemap: TileMap = get_node("TileMap")

const obstacle_tscn = preload("res://scenes/Obstacle.tscn")
const item_tscn = preload("res://scenes/Item.tscn")

var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()
	for i in 5:
		# id 0 ~ 5
		# grass, farm, forest, rocky, lava, snow
		var used_cells
		if i == 0: # farm
			used_cells = tilemap.get_used_cells_by_id(i)
		else:
			used_cells = tilemap.get_used_cells_by_id(i + 1)
		# Create Obstacles
		for j in 50:
			var obstacle = obstacle_tscn.instance()
			var used_cell_pos = rng.randi_range(0, used_cells.size() - 1)
			obstacle.set_position(used_cells[used_cell_pos] * Vector2(32, 32))
			add_child(obstacle)
		# Create Items
		for x in 3:
			for j in 10:
				var harvest = item_tscn.instance()
				var used_cell_pos = rng.randi_range(0, used_cells.size() - 1)
				harvest.set_position(used_cells[used_cell_pos] * Vector2(32, 32) + Vector2(24, 24))
				if i == 0:
					harvest.item = x
				elif i == 1: # Forest
					harvest.item = 3 + x
				elif i == 2: # Rocky
					harvest.item = 9 + x
				elif i == 3: # Lava
					harvest.item = 12 + x
				elif i == 4: # Snow
					harvest.item = 6 + x
				add_child(harvest)
