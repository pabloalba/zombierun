extends Node2D


const RUNNING = 0
const JUMPING = 1
const DEADING = 2
const FALLING = 3

var vel_x = 300
var vel_y = 300

var current_action = RUNNING
var jump = false
var attack = false
var anim = 'running'
var attacking = false
var dead_time = 0
var dead = false

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


func jump():
	if current_action == RUNNING:
		jump = true

func attack():
	if not dead and not attacking:
		attack = true
		return true
	return false

func run():
	current_action = RUNNING

func fall():
	current_action = FALLING

func die(bounce=true):
	get_node("anim").play("dead")
	if bounce:
		vel_x = - globals.ZOMBIE_SPEED_X
	else:
		vel_x = 0
	dead = true

func process(delta):
	process_movement(delta)
	process_dead(delta)
	if not dead:
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
			die()




func process_actions(delta):
	if current_action == RUNNING:
		if jump:
			vel_y = -globals.ZOMBIE_SPEED_Y
			current_action = JUMPING
			jump = false


	if not attacking and attack:
		attacking = true
		attack = false

	var new_anim = 'running'
	if attacking:
		new_anim = 'attacking'

	# Change animation
	if (new_anim != anim):
		anim = new_anim
		get_node("anim").play(anim)



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
		if current_action == JUMPING or current_action == FALLING:
			run()
	else:
		fall()

	set_pos(new_pos)


func zombie_floor_collides():
	var pos = get_pos()
	var r = Rect2(pos.x + 25, pos.y + 10, 90, 120)

	for f in globals.floors:
		if r.intersects(f.region):
			return true
	return false



