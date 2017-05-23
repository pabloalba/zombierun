extends Node2D

func process():
	if is_visible():
		zombie_collides()


func zombie_collides():
	if not globals.zombie.dead:
		var pos = globals.zombie.get_pos()
		var r = Rect2(pos.x + 25, pos.y + 10, 90, 120)
		if collides(r):
			get_node("SamplePlayer2D").play("bite")
			globals.zombie.life = min(100, globals.zombie.life+10)
			hide()


func collides(r):
	var pos = get_pos()
	var r2 = Rect2(pos.x, pos.y, 50, 50)
	return r.intersects(r2)