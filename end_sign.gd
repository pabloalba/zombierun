extends Node2D

var reached = false
var win_time = 0

func reset():
	reached = false
	win_time = 0

func process(delta):
	if !reached:
		reached =  get_pos().x + 50 <= globals.zombie.get_pos().x
		if reached:
			get_node("SamplePlayer2D").play("win")
	if reached:
		win_time += delta
