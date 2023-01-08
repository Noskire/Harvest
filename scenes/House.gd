extends StaticBody2D

onready var outline: Sprite = get_node("Outline")

var on_mission = false
var types_of_items = 15
var items = ["Cherry", "Daisy", "Blewit", "Blackberry", "Lily", "Brown Birch", "Apple", "Snowdrop", "Oyster", "Egg", "Belladonna", "Aloe Vera", "Blueberry", "Marigold", "Shitake"]
var needs = []
var rng = RandomNumberGenerator.new()

func home(player):
	if not on_mission:
		get_new_mission()
		update_RTLabel(player)
		on_mission = true
		player.play_sfx(1)
	elif test_if_complete_mission(player):
		for i in types_of_items:
			if needs[i] > 0:
				player.inventory[i] -= needs[i]
		player.update_grid()
		# get reward
		needs.clear()
		on_mission = false
		player.get_node("CanvasLayer/PanelContainer/Panel/RTLabel").set_bbcode("[u][color=green]Mission Completed![/color][/u]")
		player.play_sfx(2)

func get_new_mission():
	rng.randomize()
	for i in types_of_items:
		needs.push_back(0)
	var num_needs = rng.randi_range(2, 4)
	for i in num_needs:
		var r_pos = rng.randi_range(0, types_of_items - 1)
		var r_value = rng.randi_range(1, 5)
		needs[r_pos] += r_value

func test_if_complete_mission(player) -> bool:
	for i in types_of_items:
		if needs[i] > 0:
			if player.inventory[i] < needs[i]:
				return false
	Stats.completed_missions += 1
	player.get_node("CanvasLayer/PanelContainer/Panel/CMissions").set_bbcode("[u]Completed Missions:[/u] " + str(Stats.completed_missions))
	return true

func update_RTLabel(player):
	var head
	var rtstring = ""
	var completed = true
	for i in types_of_items:
		if needs[i] > 0:
			if player.inventory[i] < needs[i]:
				rtstring += "[i]" + items[i] + ":[/i] " + str(player.inventory[i]) + " / " + str(needs[i]) + "\n"
				completed = false
			else:
				rtstring += "[color=green][i]" + items[i] + ":[/i] " + str(player.inventory[i]) + " / " + str(needs[i]) + "[/color]\n"
	if completed:
		head = "[u][color=green]Mission:[/color][/u]\n"
	else:
		head = "[u]Mission:[/u]\n"
	player.get_node("CanvasLayer/PanelContainer/Panel/RTLabel").set_bbcode(head + rtstring)
