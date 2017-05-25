extends Node2D

var reached = false

func reset():
	reached = false


func process():
	if !reached:
		reached =  get_pos().x + 50 <= globals.zombie.get_pos().x
