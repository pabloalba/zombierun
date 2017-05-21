extends Container

var enemy
var ending_veil
var map


func _ready():
	globals.zombie = get_node("zombie1")
	globals.head = create_head()
	ending_veil = get_node("HUD/ending_veil")
	reset_map()
	set_process(true)



func reset_map():
	for b in globals.brains:
		remove_child(b)
	globals.brains = []
	globals.num_brains = 0
	for e in globals.enemies:
		remove_child(e)
	globals.enemies = []

	for s in globals.spikes:
		remove_child(s)
	globals.spikes = []

	globals.zombie.set_pos(Vector2(600, 0))
	globals.zombie.reset()

	if map:
		remove_child(map)
	map = preload("res://level1.tscn").instance()
	globals.tile_map = map.get_node("TileMap")
	add_child(map)
	load_map()
	get_node("StreamPlayer").seek_pos(0)
	get_node("StreamPlayer").play()




func load_map():
	print("load map")

	for tile in globals.tile_map.get_used_cells():
		var content = globals.tile_map.get_cell(tile.x, tile.y)
		if content == 18:
			globals.tile_map.set_cell (tile.x,tile.y, -1)
			create_enemy(tile.x * globals.TILE_SIZE, tile.y * globals.TILE_SIZE - 64)
		elif content == 19:
			globals.tile_map.set_cell (tile.x,tile.y, -1)
			create_spike(tile.x * globals.TILE_SIZE, tile.y * globals.TILE_SIZE + 32, false)
		elif content == 20:
			globals.tile_map.set_cell (tile.x,tile.y, -1)
			create_spike(tile.x * globals.TILE_SIZE + 32, tile.y * globals.TILE_SIZE + globals.TILE_SIZE, true)
		elif content == 21:
			globals.tile_map.set_cell (tile.x,tile.y, -1)
			create_end(tile.x * globals.TILE_SIZE, tile.y * globals.TILE_SIZE - 25)
		elif content == 22:
			globals.tile_map.set_cell (tile.x,tile.y, -1)
			create_brain(tile.x * globals.TILE_SIZE, tile.y * globals.TILE_SIZE)

func _process(delta):
	proces_brain_num()
	process_end_sign(delta)
	if win():
		get_node("StreamPlayer").stop()
		globals.zombie.vel_x = 0
		globals.zombie.get_node("anim").stop()
		globals.head.process(delta)
		globals.zombie.process(delta)
		if check_win_time():
			reset_map()
	else:
		if globals.zombie.dead:
			get_node("StreamPlayer").stop()
		if not check_end():
			process_fade(delta)
			process_enemies()
			process_spikes()
			process_brains()
			globals.head.process(delta)
			globals.zombie.process(delta)
		else:
			get_node("StreamPlayer").stop()
			reset_map()

func proces_brain_num():
	get_node("HUD/brains/NumBrains").set_text(str(globals.num_brains))

func process_fade(delta):
	var opacity = ending_veil.get_opacity()
	if globals.zombie.dead:
		if opacity < 1 and globals.zombie.dead_time > 1:
			ending_veil.set_opacity(opacity + (delta * 0.5))
	else:
		if opacity > 0:
			ending_veil.set_opacity(opacity - (delta * 0.5))



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

func create_end(x, y):
	var e = preload("res://end_sign.tscn").instance()
	add_child(e)
	globals.end_sign = e
	e.set_pos(Vector2(x, y))
	e.reset()
	return e

func create_brain(x, y):
	var b = preload("res://brain.tscn").instance()
	add_child(b)
	globals.brains.append(b)
	b.set_pos(Vector2(x, y))
	return b

func create_head():
	var head = preload("res://head.tscn").instance()
	add_child(head)
	head.hide()
	head.set_pos(Vector2(-1000, -1000))
	return head


func check_end():
	if globals.zombie.dead_time > 5:
		return true

func check_win_time():
	return globals.end_sign.win_time > 4


func process_enemies():
	for enemy in globals.enemies:
		enemy.process()

func process_spikes():
	for spike in globals.spikes:
		spike.process()

func process_brains():
	for brain in globals.brains:
		brain.process()

func process_end_sign(delta):
	globals.end_sign.process(delta)

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

func win():
	return (globals.end_sign.reached)





