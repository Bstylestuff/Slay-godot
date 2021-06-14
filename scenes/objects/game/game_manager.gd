extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	var space=$"UI/VBoxContainer/HBoxContainer2/GameArea".get_rect()

	var player_stuff= preload("res://scenes/objects/player/player.tscn")
	var p1=player_stuff.instance()
	var p2=player_stuff.instance()
	var p3=player_stuff.instance()
	var p4=player_stuff.instance()
	var p5=player_stuff.instance()
	var p6=player_stuff.instance()
	var p7=player_stuff.instance()
	var p8=player_stuff.instance()
	#var p9=player_stuff.instance()
	Game.add_player(p1)
	Game.add_player(p2)
	Game.add_player(p3)
	Game.add_player(p4)
	Game.add_player(p5)
	Game.add_player(p6)
	Game.add_player(p7)
	Game.add_player(p8)
	Game.prepare_game(space)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
