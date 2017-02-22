extends Container

const TILE_SIZE = 64

var enemy
var map


func _ready():
	globals.zombie = get_node("zombie1")
	globals.head = create_head()
	reset_map()
	set_process(true)


func reset_map():
	for e in globals.enemies:
		remove_child(e)
	globals.enemies = []

	for s in globals.spikes:
		remove_child(s)
	globals.spikes = []

	for f in globals.floors:
		remove_child(f)
	globals.floors = []

	globals.zombie.set_pos(Vector2(600, 0))
	globals.zombie.reset()

	if map:
		remove_child(map)
	map = preload("res://level1.tscn").instance()
	add_child(map)

	load_map(map)




func load_map(map):
	print("load map")
	var tm = map.get_node("TileMap")
	for tile in tm.get_used_cells():
		var content = tm.get_cell(tile.x, tile.y)
		if content == 18:
			tm.set_cell (tile.x,tile.y, -1)
			create_enemy(tile.x * TILE_SIZE, tile.y * TILE_SIZE - 64)
		elif content == 19:
			tm.set_cell (tile.x,tile.y, -1)
			create_spike(tile.x * TILE_SIZE, tile.y * TILE_SIZE + 32, false)
		elif content == 20:
			tm.set_cell (tile.x,tile.y, -1)
			create_spike(tile.x * TILE_SIZE + 32, tile.y * TILE_SIZE + TILE_SIZE, true)
		else:
			create_floor(tile.x * TILE_SIZE, tile.y * TILE_SIZE)




func _process(delta):
	if not check_end():
		process_enemies()
		process_spikes()
		globals.head.process(delta)
		globals.zombie.process(delta)
	else:
		reset_map()



func create_floor(x, y):
	var current_floor = preload("res://virtual_floor.tscn").instance()
	add_child(current_floor)
	globals.floors.append(current_floor)
	current_floor.set_dimension(x, y, 64, 64)
	return current_floor


func create_enemy(x, y):
	var e = preload("res://enemy.tscn").instance()
	add_child(e)
	globals.enemies.append(e)
	e.set_pos(Vector2(x, y))
	e.reset()
	return e

func create_spike(x, y, vertical):
	var s = preload("res://spike.tscn").instance()
	add_child(s)
	globals.spikes.append(s)
	s.set_pos(Vector2(x, y))
	s.set_vertical(vertical)
	return s

func create_head():
	var head = preload("res://head.tscn").instance()
	add_child(head)
	head.hide()
	head.set_pos(Vector2(-1000, -1000))
	return head


func check_end():
	if globals.zombie.dead_time > 3:
		return true

func process_enemies():
	for enemy in globals.enemies:
		enemy.process()

func process_spikes():
	for spike in globals.spikes:
		spike.process()


func _on_btn_jump_input_event( event ):
	if event.type == InputEvent.MOUSE_BUTTON \
    and event.button_index == BUTTON_LEFT \
    and event.pressed:
		globals.zombie.jump()


func _on_btn_attack_input_event( event ):
	if event.type == InputEvent.MOUSE_BUTTON \
    and event.button_index == BUTTON_LEFT \
    and event.pressed:
		if globals.zombie.attack():
			globals.head.start_attack()







