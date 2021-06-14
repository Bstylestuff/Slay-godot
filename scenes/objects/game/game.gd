extends Node


var Players=[]
var time=0

var hexes=[]
var player_spaces=[]
var colors=["green", "dark_blue", "red", "purple", "pink", "orange","emerald","black"]
var hex=preload("res://scenes/objects/hex/hexagon.tscn")
var empty_player=preload("res://scenes/objects/player/player.tscn")
var x =10
var y =20
var players
var chart_node

func Next_Turn():
	#Ends current player turn, sends to server 
	#If server, updates everyone on last turn and sends the turn to the next one
	pass

func add_player(player):
	Players.append(player)
	
func prepare_game(space):
	#Mixup the list of players
	var rng = RandomNumberGenerator.new()
	randomize()
	rng.randi_range(0,100)
	Players.shuffle()
	for i in range(0,len(Players)):
		Players[i].set_color(colors[i])
		
	for player_index in len(Players):
		var slant_amount=player_index+1
		while slant_amount>0:
			player_spaces.append(Players[player_index])
			slant_amount=slant_amount-1

# Called when the node enters the scene tree for the first time.
	
	var w=space.size.x
	var h=space.size.y
	var px=space.position.x
	var py=space.position.y
	start(x,y,Players,px,py,w,h)


func start(x,y,players,originx,originy,w,h):
	prepare_hexes(x,y,originx,originy,w,h)
	assign_hexes()
	show_hexes()
	
	#print(self.get_path())
	#print(get_tree().get_scene)
	#print($main_chart_scene)
	chart_node = get_parent().get_node("/root/GameScene/UI/VBoxContainer/HBoxContainer2/Button3/Chart/main_chart_Scene")
	#chart_node.initial()
	update_chart()
	chart_node.initial()
	update_houses()

func update_chart():
	var player_list=[]
	var hexlist=[]+hexes
	var count=0
	for p in Players:
		if (p.colour!="black"):
			count=0
			for h in hexlist:
				if(p.colour==h.player_color):
					count+=1
					hexlist.erase(h)
			player_list.append(count)
	chart_node.update_chart(player_list)

func prepare_hexes(x,y,px,py,w,h):
	var count=0
	for i in range(y):
		for j in range(x):
			var newhex=hex.instance()
			var size = newhex.get_size()
			newhex.coordinates=[i,j]
			if(i%2==0):
				newhex.position=Vector2((w/2-px-100)-size.x*(j*2.4-1.2),(h/2-py)-size.y*(i*1))
			else:
				newhex.position=Vector2((w/2-px-100)-size.x*(j*2.4),(h/2-py)-size.y*(i*1)-py)
			newhex.change_label("x:"+str(j)+" y:"+str(i))
			newhex.change_label(str(count))
			hexes.append(newhex)
			count+=1

func assign_hexes():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	if(len(player_spaces)<len(hexes)):
		player_spaces.shuffle()
		while(len(player_spaces)<len(hexes)):
			var rand=rng.randi_range(0,100)
			if(rand%99==0):
				var empty= empty_player.instance()
				player_spaces.append(empty)
			else:
				var p = player_spaces[1]
				player_spaces.append(p)
			player_spaces.shuffle()
	
	for i in range (0,len(hexes)):
		hexes[i].call_deferred("change_owner", player_spaces[i].get_color())
		hexes[i].player_color=player_spaces[i].get_color()
		#print(player_spaces[i].get_color())
		hexes[i].set_neighbours(find_neighbours(int(floor(i/x)),i%x))

func show_hexes():
	for hex in hexes:
		get_parent().call_deferred("add_child", hex)
		#UI/VBoxContainer/HBoxContainer2/GameArea/Game_Viewport
		#get_tree().get_root().get_node("GameScene").find_node("Game_Viewport").add_child(hex)
		if(hex.get_color()=="black"):
			hex.hide()
	pass

func update_houses():
	var regions=[]
	var owned=[]
	var check_order=[]
	var hex_color
	var hex_neighbours=[]
	var all_hexes=[]+hexes
	for hex in all_hexes:
		if hex.player_color=="black":
			all_hexes.erase(hex)
	while(len(all_hexes)>0):
		hex=all_hexes[0]
		owned=[]
		check_order=[]
		hex_color=hex.player_color
		if(hex_color=="black"):
			all_hexes.remove(0)
		else:
			hex_neighbours=[]
			owned.append(hex)
			all_hexes.erase(hex)
			check_order.append(hexes.find(hex))
			var region=[hex]
			while(len(check_order)>0):
				for neighbour_index in hexes[check_order[0]].get_neighbours():
					if(hexes[neighbour_index].player_color==hex_color):
						if(hexes[neighbour_index]in region):
							pass
						else:
							region.append(hexes[neighbour_index])
							if (neighbour_index in check_order):
								pass
							else:
								check_order.append(neighbour_index)
							if(all_hexes.find(hexes[neighbour_index])!=-1):
								all_hexes.remove(all_hexes.find(hexes[neighbour_index]))
				check_order.erase(check_order[0])
			regions.append(region)
	var rng = RandomNumberGenerator.new()
	var longest=0
	for region in regions:
		if(len(region)>longest):
			longest=len(region)
		rng.randomize()
		if(len(region)>1):
			var num=rng.randi_range(0, len(region)-1)
			region[num].show_house()

func find_neighbours(i,j):
	var neighbours=[]
	#case i=0
	if(i==0):
		if(j==0):
			neighbours.append(x)
			neighbours.append(x*2)
		else:
			neighbours.append(2*x+j)
			if(j<x-1):
				neighbours.append(x+j)
				neighbours.append(x+j-1)
			else:
				neighbours.append(x+x-1)
				neighbours.append(x+x-2)
				##GOTTa TREAT i=y-2
	else:
		if(i==1):
			neighbours.append(j)
			neighbours.append(2*x+j)
			neighbours.append(3*x+j)
			if (j+1<x-1):
				neighbours.append(j+1)
				neighbours.append(2*x+j+1)
			else:
				if(j+1==x-1):
					neighbours.append(2*x+j+1)
					neighbours.append(j+1)
		else:
			#i=y-1
			if(i==y-1):
				if(j==0):
					#neighbours.append(x*i)
					neighbours.append(x*(i-1))
					neighbours.append(x*(i-2))
					neighbours.append(x*(i-1)+1)
				else:
					if(j<x-1):
						neighbours.append(x*(i-1)+j)
						neighbours.append(x*(i-2)+j)
						neighbours.append(x*(i-1)+j+1)
					else:
						neighbours.append(x*i-1)
						neighbours.append(x*(i-1)-1)
			else:
				if(i==y-2):
					neighbours.append(x*(i-1)+j)
					neighbours.append(x*(i-2)+j)
					neighbours.append(x*(i+1)+j)
					if(j>0):
						neighbours.append(x*(i-1)+j-1)
						neighbours.append(x*(i+1)+j-1)
				else:
						#j=0, i not edge
					if(j==0):
						neighbours.append(x*i+1)
						neighbours.append(x*(i-2))
						neighbours.append(x*(i-1))
						neighbours.append(x*(i+2))
						if(i%2==1):
							neighbours.append(x*(i-1)+1)
							neighbours.append(x*(i+1)+1)
					else:		
						if(j==x-1):

							neighbours.append(x*(i-2)+j)
							neighbours.append(x*(i+1)+j)
							neighbours.append(x*(i+2)+j)
							neighbours.append(x*(i-1)+j)
							if(int(i)%2==0):
								neighbours.append(x*(i-1)+j-1)
								neighbours.append(x*(i+1)+j-1)
						else:
								#GENERAL CENTER CASES
							if(j<x-1):
								neighbours.append(x*(i+1)+j)
								neighbours.append(x*(i-2)+j)
								neighbours.append(x*(i-1)+j)
								neighbours.append(x*(i+2)+j) #even
								if(int(i)%2==0):								
									neighbours.append(x*(i+1)+j-1)
									neighbours.append(x*(i-1)+j-1) #odd
								else:
									neighbours.append(x*(i+1)+j+1)
									neighbours.append(x*(i-1)+j+1) #odd
							
	return neighbours
