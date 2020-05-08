extends Area2D

var coordinates=[]
var player_color=""
var unit


func _input_event(_viewport, event, _shape_idx):
	if event is InputEventScreenTouch \
	and event.button_index == BUTTON_LEFT \
	and event.is_pressed():
		self.on_click()

	
func on_click():
	print("Click")
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


func _on_Area2D_input_event(viewport, event, shape_idx):
	if event is InputEventScreenTouch:
		self.on_click()
