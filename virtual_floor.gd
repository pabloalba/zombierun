extends Node2D

var region

func _ready():
	pass

func set_dimension(x, y, width, height):
	region = Rect2(x, y, width, height)