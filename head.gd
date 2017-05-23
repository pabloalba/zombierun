extends Node2D

const HEAD_SPEED = 900

var head_return = false

func _ready():
	set_z(2)

func start_attack():
	var zombie_pos = globals.zombie.get_pos()
	var pos = Vector2()
	pos.x = zombie_pos.x + 30
	pos.y = zombie_pos.y + 50
	set_pos(pos)
	head_return = false
	show()

func end_attack():
	hide()
	set_pos(Vector2(0,2000))
	globals.zombie.attacking = false

func process(delta):
#	enemy_killed = null
	if is_visible():
		var head_pos = get_pos()
		var zombie_pos = globals.zombie.get_pos()

		if zombie_pos.x + 75 >= head_pos.x:
			if head_return:
				end_attack()
			else: # never should be behind!
				head_pos.x = zombie_pos.x + 75


		if head_pos.x - zombie_pos.x > 350:
			head_return = true

		head_pos.y = zombie_pos.y + 40
		if not head_return:
			head_pos.x += delta * HEAD_SPEED
		else:
			head_pos.x -= delta * (HEAD_SPEED - globals.ZOMBIE_SPEED_X)
		set_pos(head_pos)