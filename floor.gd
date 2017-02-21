extends Node2D

var region

func _ready():
	set_z(0)
	var sprite = get_node("Sprite")
	region = sprite.get_item_rect()

