extends Node2D

var reached = false
var win_time = 0

func reset():
	reached = false
	win_time = 0

func process(delta):
	reached =  get_pos().x + 50 <= globals.zombie.get_pos().x
	if reached:
		win_time += delta
