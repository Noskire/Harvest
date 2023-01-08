extends Area2D

onready var tilemap: TileMap = get_parent().get_node("TileMap")
onready var outline: Sprite = get_node("Outline")
onready var sprite: Sprite = get_node("Sprite")
onready var collision: CollisionShape2D = get_node("Collision")
onready var anim: AnimationPlayer = get_node("AnimationPlayer")
onready var timer: Timer = get_node("GrowTime")

export(int, "Cherry", "Daisy", "Blewit", "Blackberry", "Lily", "Brown Birch", "Apple", "Snowdrop", "Oyster", "Egg", "Belladonna", "Aloe Vera", "Blueberry", "Marigold", "Shitake") var item = 0

var growing = false
var grow_time = 30.0
var rng = RandomNumberGenerator.new()

func _ready():
	sprite.set_frame(item)
	outline.set_frame(item)

func harvest() -> int:
	if not growing:
		growing = true
		anim.play("Harvest")
		return item
	else:
		return -1

func start_to_grow():
	timer.set_wait_time(grow_time)
	timer.start()

func _on_GrowTime_timeout():
	rng.randomize()
	# Change position
	# grass (0), farm (1), forest (2), rocky (3), lava (4), snow (5)
	var area = int(item / 3)
	var i
	if area == 0: # Grass
		i = 0
	elif area == 1: # Forest
		i = 2
	elif area == 2: # Snow
		i = 5
	elif area == 3: # Rocky
		i = 3
	elif area == 4: # Lava
		i = 4
	var used_cells = tilemap.get_used_cells_by_id(i)
	var used_cell_pos = rng.randi_range(0, used_cells.size() - 1)
	set_position(used_cells[used_cell_pos] * Vector2(32, 32) + Vector2(24, 24))
	
	growing = false
	sprite.modulate.a = 1
	collision.set_disabled(false)
