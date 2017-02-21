extends Container


var enemy

func _ready():
	globals.zombie = get_node("zombie1")
	globals.head = create_head()
	reset_map()
	set_process(true)


func reset_map():
	for e in globals.enemies:
		remove_child(e)
	globals.enemies = []

	for f in globals.floors:
		remove_child(f)
	globals.floors = []

	globals.zombie.set_pos(Vector2(500, 200))
	globals.zombie.reset()
	create_floor(500, 430)
	create_floor(850, 430)
	create_floor(1300, 530)
	create_floor(1700, 530)
	create_floor(2400, 530)
	create_floor(2800, 530)
	create_floor(3300, 530)
	create_floor(3800, 470)
	create_floor(4400, 420)


	create_enemy(3000, 410)
	create_enemy(4500, 300)

	create_spike(1700, 485, false)



func _process(delta):
	if not check_end():
		process_enemies()
		process_spikes()
		globals.head.process(delta)
		globals.zombie.process(delta)
	else:
		reset_map()



func create_floor(x, y):
	# Search for a free floor
	var current_floor
	#for f in floors:
	#	if not f.is_visible():
	#		current_floor = f
	#		break
	if not current_floor:
		current_floor = preload("res://floor.tscn").instance()
		add_child(current_floor)
		globals.floors.append(current_floor)
	current_floor.set_pos(Vector2(x, y))
	current_floor.region.pos = Vector2(x, y)
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







