extends Node

var active_player

func initialize():
	active_player=get_child(0)
func play_turn():
	yield(active_player.play_turn(), "completed")
	active_player=get_child((active_player.get_index()+1)%get_child_count())
	#alternatively, split it, so 
	#var index=(active_player.get_index()+1)%get_child_count()
	#active_player=get_child(index)
