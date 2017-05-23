extends Node2D

var near = false
var attacking = false
var dead = false
var current_anim = "idle"
var anim


func _ready():
	anim = get_node("anim")
	set_z(2)

func attack():
	if not dead and not attacking:
		attacking = true
		anim.play("sword")

func die():
	anim.play("die")
	dead = true

func process():
	if not dead:
		if get_pos().x - globals.zombie.get_pos().x < 200:
			attack()
		zombie_collides()
		head_collides()




func reset():
	near = false
	attacking = false
	dead = false
	current_anim = "idle"


func zombie_collides():
	if not dead and not globals.zombie.dead:
		var pos = globals.zombie.get_pos()
		var r = Rect2(pos.x + 25, pos.y + 10, 90, 120)
		if collides(r):
			globals.zombie.die("SLICED!")

func head_collides():
	if not dead:
		var pos = globals.head.get_pos()
		var r = Rect2(pos.x, pos.y, 10, 10)
		if collides(r):
			globals.head.head_return = true
			die()


func collides(r):
	var pos = get_pos()
	var r2 = Rect2(pos.x+30, pos.y, 100, 120)
	return r.intersects(r2)
