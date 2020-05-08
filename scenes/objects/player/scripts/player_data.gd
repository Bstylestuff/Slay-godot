extends Node

var Player_Name=""

func Load():
	print("loading")
	var savegame = File.new()
	if !savegame.file_exists("user://savegame.save"):
		print("no file, so let's make one")
		return "Fresh Blewd"
	#TODO: Ask to make a file
		
	# Load the file line by line and process that dictionary to restore the object it represents
	var currentline = {} # dict.parse_json() requires a declared dict.
	savegame.open("user://savegame.save", File.READ)
	currentline=parse_json(savegame.get_line())
	print(currentline)
	while (!savegame.eof_reached()):
		# First we need to create the object and add it to the tree and set its position.
		for i in currentline.keys():
			if (i == "Player_Name"):
				Player_Name=currentline[i]
		currentline=parse_json(savegame.get_line())
	savegame.close()

func Save():
	var savegame = File.new()
	savegame.open("user://savegame.save", File.WRITE)
	var nodedata = serialize()
	print(nodedata)
	var jstr = JSON.print(nodedata)
	print(jstr)
	savegame.store_line(jstr)
	savegame.close()

func serialize():
	var savedict = {
		filename=get_filename(),
		parent=get_parent().get_path(),
		Player_Name=Player_Name
	}
	return savedict

func add_Player(Pname):
	print(Pname)
	Player_Name=Pname
	Save()
	Load()
