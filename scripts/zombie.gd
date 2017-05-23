extends Node2D

const RUNNING = 0
const JUMPING = 1
const DEADING = 2
const FALLING = 3
const DOUBLE_JUMPING = 4

var vel_x = 300
var vel_y = 300

var current_action = RUNNING
var jump = false
var double_jump = false
var double_jump_ready = false
var attack = false
var anim = 'running'
var attacking = false
var dead_time = 0
var dead = false
var current_zombie = ''
var life = 100
var death_cause = "DEAD!"

func _ready():
	set_z(1)


func reset():
	current_action = RUNNING
	jump = false
	attack = false
	anim = 'running'
	dead_time = 0
	dead = false
	get_node("Sprite").set_flip_h(false)
	get_node("anim").play("running")
	vel_x = globals.ZOMBIE_SPEED_X
	vel_y = globals.ZOMBIE_SPEED_Y
	current_zombie = ''
	life = 100
	death_cause = "DEAD!"


func jump():
	if current_action == RUNNING:
		jump = true
		get_node("SamplePlayer2D").play("jump")

func double_jump():
	if current_action == RUNNING:
		jump()
	elif current_action == JUMPING or current_action == FALLING:
		if double_jump_ready:
			double_jump_ready = false
			double_jump = true
			get_node("SamplePlayer2D").play("jump")



func attack():
	if not dead and not attacking:
		attack = true
		get_node("SamplePlayer2D").play("grunt")
		return true
	return false

func run():
	current_action = RUNNING

func fall():
	current_action = FALLING

func die(cause="DEAD!", bounce=true):
	if !dead:
		death_cause = cause
		get_node("SamplePlayer2D").play("ouch")
	get_node("anim").play(current_zombie+"dead")
	if bounce:
		vel_x = - globals.ZOMBIE_SPEED_X
	else:
		vel_x = 0
	dead = true

func process(delta):
	process_movement(delta)
	process_dead(delta)
	if not dead:
		life -= delta * 5
		process_actions(delta)


func process_dead(delta):
	if dead:
		dead_time += delta
		if dead_time > 0.3:
			vel_x = 0
	else:
		# Dead by fall
		var zombie_pos = get_pos()
		if zombie_pos.y >= globals.HEIGHT + 150:
			die("ABYSS!")

		# Dead by life
		if life <= 0:
			die("BRAAAAINS!")




func process_actions(delta):
	if current_action == RUNNING:
		if jump:
			vel_y = -globals.ZOMBIE_SPEED_Y
			current_action = JUMPING
			jump = false
	elif current_action == JUMPING or current_action == FALLING:
		if double_jump:
			vel_y = -globals.ZOMBIE_SPEED_Y
			current_action = DOUBLE_JUMPING
			double_jump = false


	if not attacking and attack:
		attacking = true
		attack = false

	var new_anim = 'running'
	if attacking:
		new_anim = 'attacking'

	# Change animation
	if (new_anim != anim):
		anim = new_anim
		get_node("anim").play(current_zombie + anim)



func process_movement(delta):
	var pos = get_pos()
	var new_pos = Vector2()
	new_pos.x = pos.x
	new_pos.y = pos.y

	# Fall
	if vel_y < globals.ZOMBIE_SPEED_Y:
		vel_y += delta * globals.ZOMBIE_GRAVITY
	else:
		vel_y = globals.ZOMBIE_SPEED_Y

	# Move x
	new_pos.x += delta * vel_x
	set_pos(new_pos)
	var collide = zombie_floor_collides()
	if collide:
		# undo x move
		new_pos.x = pos.x

	# Move y
	new_pos.y += delta * vel_y
	set_pos(new_pos)
	collide = zombie_floor_collides()
	if collide:
		# undo y move
		new_pos.y = pos.y
		if current_action == JUMPING or current_action == DOUBLE_JUMPING or current_action == FALLING:
			double_jump_ready = true
			run()
	else:
		fall()

	set_pos(new_pos)


func zombie_floor_collides():
	var pos = get_pos()
	var r = Rect2(pos.x + 25, pos.y + 10, 90, 120)

	var fx0 = (pos.x / 64) + 1
	var fy0 = (pos.y / 64) + 1

	for fx in range(fx0, fx0+2):
		for fy in range (fy0, fy0+2):
			var content = globals.tile_map.get_cell(fx, fy)
			if content >=0:
				var region = Rect2(fx * globals.TILE_SIZE, fy * globals.TILE_SIZE, globals.TILE_SIZE, globals.TILE_SIZE)
				if r.intersects(region):
					return true
	return false

func become(new_zombie_type):
	if current_action == RUNNING or current_action == JUMPING or current_action == FALLING:
		current_zombie = new_zombie_type
		double_jump_ready = true
		anim = ''
		return true
	return false


