extends Viewport

#var hex=preload("res://scenes/objects/hex/hexagon.tscn")
#var hexes=[]
#var x =10
#var y =10 
# players
# Called when the node enters the scene tree for the first time.

	
func _input(ev) -> void:
	
	get_viewport().unhandled_input(ev)
#func start(x,y,players,originx,originy,w,h):
#	prepare_hexes(x,y,originx,originy,w,h)
#	randomize_hexes()
#	show_hexes()
#
#func prepare_hexes(x,y,px,py,w,h):
#
#	for i in range(y):
#		for j in range(x):
#			var newhex=hex.instance()
#			var size = newhex.get_size()
#			if(i%2==0):
#				newhex.position=Vector2(size.x*(j*2.4-1.2),50+size.y*(i*1))
#			else:
#				newhex.position=Vector2(size.x*(j*2.4),50+size.y*(i*1))
#				pass
#			hexes.append(newhex)
#
#func randomize_hexes():
#	var rng = RandomNumberGenerator.new()
#	for hex in hexes:
#		hex.call_deferred("change_color",rng.randf_range(0, 1.0), rng.randf_range(0, 1.0), rng.randf_range(0, 1.0))
#		##sp.modulate = Color(rng.randf_range(0, 1.0), rng.randf_range(0, 1.0), rng.randf_range(0, 1.0)) # blue shade
#		#hex.call_deferred("change_color",)
#func show_hexes():
#	for hex in hexes:
#		get_parent().call_deferred("add_child", hex)
#		print(hex)
#	pass
