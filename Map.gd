extends Container



func _ready():
	load_game()
	for i in range(1, globals.max_level+1):
		get_node("BG/level_open_"+str(i)).show()

	for i in range(globals.max_level+1, 26):
		get_node("BG/level_open_"+str(i)).hide()


func load_game():
	var savegame = File.new()
	if !savegame.file_exists("user://zombie_savegame.save"):
		return #Error!  We don't have a save to load
	var currentline = {}
	savegame.open("user://zombie_savegame.save", File.READ)
	currentline.parse_json(savegame.get_line())
	globals.max_level = int(currentline["max_level"])
	globals.ninja_allowed = bool(currentline["ninja_allowed"])
	globals.cowboy_allowed = bool(currentline["max_level"])
	savegame.close()



func _on_level_open_input_event( event, num ):
	if event.type == InputEvent.MOUSE_BUTTON \
	    and event.button_index == BUTTON_LEFT \
	    and event.pressed:
			load_level(num)


func load_level(level):
	print("load level")
	globals.current_level = level
	get_tree().change_scene("res://main.tscn")
