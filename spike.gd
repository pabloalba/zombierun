extends Node2D

const WIDTH = 64
const HEIGHT = 32

var vertical = false
func _ready():
	set_z(3)

func set_vertical(v):
	vertical = v
	if vertical:
		get_node("Sprite").set_rotd(90)
	else:
		get_node("Sprite").set_rotd(0)




func process():
	zombie_collides()


func zombie_collides():
	if not globals.zombie.dead:
		var pos = globals.zombie.get_pos()
		var r = Rect2(pos.x + 25, pos.y + 10, 90, 120)
		if collides(r):
			globals.zombie.die(false)


func collides(r):
	var pos = get_pos()
	var r2
	if vertical:
		r2 = Rect2(pos.x, pos.y-WIDTH, HEIGHT, WIDTH)
	else:
		r2 = Rect2(pos.x, pos.y, WIDTH, HEIGHT)

	return r.intersects(r2)
