extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _draw():
	draw_line(Vector2(10,5), Vector2(300, 5), Color(118, 0, 150), 1)
	draw_line(Vector2(10,5), Vector2(10,16), Color(118, 0, 150), 1)
	draw_line(Vector2(10,15), Vector2(300, 15), Color(118, 0, 150), 1)
	draw_line(Vector2(300,5), Vector2(300,15), Color(118, 0, 150), 1)

	draw_line(Vector2(10,10), Vector2(max(globals.zombie.life * 3, 10), 10), Color(118, 0, 150), 50)

#func update():
#	CanvasItem.update()