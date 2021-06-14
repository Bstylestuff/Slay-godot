extends Area2D

var coordinates=[]
var player_color=""
var unit

var colors={"green":[50,255,0], "dark_blue":[5,0,255], "red":[255,0,0], "purple":[157,0,255], "pink":[255,0,255], 
	"orange":[255,150,0],"emerald":[0,250,180],"black":[0,0,0]}

var neighbours=[]

func _ready():
	input_pickable=true
	get_neighbours()

func _input_event(_viewport, event, _shape_idx):
	if event is InputEventScreenTouch \
	and event.is_pressed():
		self.on_click()

	
func on_click():
	var c=$Sprite.modulate
	change_owner("black")
	#check if player owns this tile.
		#If not, check if player has already selected unit
		#	if not, ignore.
		#	if player has selected unit, check if it can take tile (unit vs value of unit here)
		#		if possible, check if selected unit can get here
		#			if so, update this and that unit, update board as well
					
	#If player owns this tile, check if there is unit on tile
	#	if so, check if there is another selected unit
	#		if so, check if it can reach this tile
	#			if so, merge them
	#		otherwise, ignore
	#	if no other selected unit, select the one on this tile. 
	#	#Otherwise, if there is an already selected unit, 
	#		check if it can come here
	#			if so, move it, update it and this tile
	#		otherwise, ignore 
func _input(ev) -> void:
	get_viewport().unhandled_input(ev)

func _on_Area2D_input_event(viewport, event, shape_idx):
	if event is InputEventScreenTouch or event is InputEventMouseButton:
		self.on_click()

func change_owner(player_color_new):
	player_color=player_color_new
	$Sprite.modulate = Color(colors[self.player_color][0]/255.0,colors[self.player_color][1]/255.0,colors[player_color][2]/255.0) # blue shade
	#$Label.text=player_color
	#print(player_color)
func get_size():
	return $Sprite.texture.get_size()

func get_neighbours():
	return neighbours

func get_color():
	return player_color

func hide():
	$Sprite.visible=false

func show_house():
	$House.visible=true
func change_label(text):
	$Label.text=text
	$Label.visible=true

func set_neighbours(neighbour_list):
	neighbours=neighbour_list
