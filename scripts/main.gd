extends Container

var enemy
var ending_veil
var map
var life_bar
var paused = false
var current_help = 0

func _ready():
	globals.zombie = get_node("zombie1")
	globals.head = create_head()
	ending_veil = get_node("HUD/ending_veil")
	reset_map()
	set_process(true)

	life_bar = preload("res://life_bar.tscn").instance()
	life_bar.set_pos(Vector2(75, 25))
	get_node("HUD").add_child(life_bar)
	paused = false



func reset_map():
	save_game()
	get_node("HUD/death_note").set_text("")
	get_node("HUD/paused_control").hide()
	current_help = 0

	for b in globals.brains:
		remove_child(b)
	globals.brains = []
	for e in globals.enemies:
		remove_child(e)
	globals.enemies = []

	for s in globals.spikes:
		remove_child(s)
	globals.spikes = []

	for s in globals.help_signs:
		remove_child(s)
	globals.help_signs = []

	globals.zombie.set_pos(Vector2(600, 0))
	globals.zombie.reset()

	choose_buttons()

	if map:
		remove_child(map)
	var text_level = '%03d' % globals.current_level
	map = load("res://levels/level" + text_level + ".tscn").instance()
	globals.tile_map = map.get_node("TileMap")
	add_child(map)
	get_node("HUD/btn_ninja").hide()

	if globals.ninja_allowed:
		get_node("HUD/btn_ninja").show()


	load_map()
	get_node("StreamPlayer").seek_pos(0)
	get_node("StreamPlayer").play()
	#get_node("StreamPlayer").set_volume(0)



func load_map():
	print("load map")

	for tile in globals.tile_map.get_used_cells():
		var content = globals.tile_map.get_cell(tile.x, tile.y)
		if content == 18:
			globals.tile_map.set_cell (tile.x,tile.y, -1)
			create_enemy(tile.x * globals.TILE_SIZE - 32, tile.y * globals.TILE_SIZE - 64)
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
			create_brain(tile.x * globals.TILE_SIZE + 32, tile.y * globals.TILE_SIZE)
		elif content == 23:
			globals.tile_map.set_cell (tile.x,tile.y, -1)
			create_help(tile.x * globals.TILE_SIZE, tile.y * globals.TILE_SIZE - 25)

func _process(delta):
	if not paused:
		process_end_sign(delta)
		if win():
			get_node("HUD/death_note").add_color_override("font_color", Color(0,255,0))
			get_node("HUD/death_note").set_text("CLEAR!")
			get_node("StreamPlayer").stop()
			globals.zombie.vel_x = 0
			globals.zombie.get_node("anim").stop()
			globals.head.process(delta)
			globals.zombie.process(delta)
			if check_win_time():
				load_next_level()
		else:
			process_zombie_life(delta)
			if globals.zombie.dead:
				get_node("HUD/death_note").add_color_override("font_color", Color(255,0,0))
				get_node("HUD/death_note").set_text(globals.zombie.death_cause)
				get_node("StreamPlayer").stop()
			if not check_end():
				process_fade(delta)
				process_enemies()
				process_spikes()
				process_brains()
				process_help()
				globals.head.process(delta)
				globals.zombie.process(delta)
			else:
				get_node("StreamPlayer").stop()
				reset_map()

func load_next_level():
	if globals.current_level == globals.max_level:
		globals.max_level = min(25, globals.max_level + 1)
	globals.current_level = min(25, globals.current_level + 1)
	save_game()
	reset_map()

func process_zombie_life(delta):
	life_bar.update()

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

func create_help(x, y):
	var e = preload("res://help_sign.tscn").instance()
	add_child(e)
	globals.help_signs.append(e)
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
	if globals.zombie.dead_time > 3:
		return true

func check_win_time():
	return globals.end_sign.win_time > 4


func process_enemies():
	for enemy in globals.enemies:
		if not enemy.dead:
			enemy.process()
			if enemy.dead:
				create_brain(enemy.get_pos().x + 65, enemy.get_pos().y + 60)

func process_spikes():
	for spike in globals.spikes:
		spike.process()

func process_brains():
	for brain in globals.brains:
		brain.process()

func process_help():
	for h in globals.help_signs:
		if not h.reached:
			h.process()
			if h.reached:
				show_help()

func process_end_sign(delta):
	globals.end_sign.process(delta)

func show_help():
	paused = true
	get_node("HUD/paused_control/help_label").set_bbcode(map.help_texts[current_help])
	get_node("HUD/paused_control").show()

func hide_help():
	get_node("HUD/paused_control").hide()
	paused = false
	current_help += 1

func win():
	return (globals.end_sign.reached)

func input_enabled():
	return not (globals.end_sign.reached or globals.zombie.dead or paused)

func choose_buttons():
	if globals.zombie.current_zombie == '':
		get_node("HUD/btn_jump").show()
		get_node("HUD/btn_double_jump").hide()
		get_node("HUD/btn_attack").show()
		get_node("HUD/btn_ninja").show()
		get_node("HUD/btn_zombie").hide()
	elif globals.zombie.current_zombie == 'ninja':
		get_node("HUD/btn_jump").hide()
		get_node("HUD/btn_double_jump").show()
		get_node("HUD/btn_attack").hide()
		get_node("HUD/btn_ninja").hide()
		get_node("HUD/btn_zombie").show()


func save_game():
	var savegame = File.new()
	savegame.open("user://zombie_savegame.save", File.WRITE)
	var json = str('{"max_level":', str(globals.max_level), ',"ninja_allowed":', str(globals.ninja_allowed).to_lower(), ',"cowboy_allowed":', str(globals.cowboy_allowed).to_lower(),'}')
	savegame.store_line(json)
	savegame.close()




func _on_btn_jump_input_event( event ):
	if input_enabled():
		if event.type == InputEvent.MOUSE_BUTTON \
	    and event.button_index == BUTTON_LEFT \
	    and event.pressed:
			globals.zombie.jump()


func _on_btn_attack_input_event( event ):
	if input_enabled():
		if event.type == InputEvent.MOUSE_BUTTON \
	    and event.button_index == BUTTON_LEFT \
	    and event.pressed:
			if globals.zombie.attack():
				globals.head.start_attack()

func _on_btn_ninja_input_event( event ):
	if input_enabled():
		if event.type == InputEvent.MOUSE_BUTTON \
	    and event.button_index == BUTTON_LEFT \
	    and event.pressed:
			if globals.zombie.become('ninja'):
				choose_buttons()

func _on_btn_zombie_input_event( event ):
	if input_enabled():
		if event.type == InputEvent.MOUSE_BUTTON \
	    and event.button_index == BUTTON_LEFT \
	    and event.pressed:
			if globals.zombie.become(''):
				choose_buttons()


func _on_btn_double_jump_input_event( event ):
	if input_enabled():
		if event.type == InputEvent.MOUSE_BUTTON \
	    and event.button_index == BUTTON_LEFT \
	    and event.pressed:
			globals.zombie.double_jump()


func _on_paused_control_input_event( event ):
	if event.type == InputEvent.MOUSE_BUTTON \
	    and event.button_index == BUTTON_LEFT \
	    and event.pressed:
			hide_help()


func _on_help_label_input_event( event ):
	_on_paused_control_input_event( event )
