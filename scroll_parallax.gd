extends ParallaxLayer

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	set_process(true)

func _process(delta):
	var pos = get_pos()
	var zombie_pos = globals.zombie.get_pos()
	var rnd = int(round (zombie_pos.x / 64))
	var dec = (zombie_pos.x / 64)  - rnd
	pos.x = -((rnd % globals.WIDTH) + dec)
	set_pos(pos)
