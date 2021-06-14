extends Control

onready var chart_node = get_node('chart')

func reset():
  chart_node.create_new_point({
	values = {
	  player1 = 150,
	  player2 = 1025,
	  player3 = 1050,
	  player4=600,
	  player5 = 150,
	  player6 = 1025,
	  player7 = 1050
	}
  })

func update_chart(value_list):
	var value={}
	var count=1
	for v in value_list:
		value['player'+str(count)]=v
		count+=1
	chart_node.create_new_point({
		values=value
		})

func initial():
	var p_dict={}
	var count=1
	for p in Game.Players:
		if(p.colour!="black"):
			p_dict["player"+str(count)] = Color(Globals.COLORS[p.colour][0]/255.0,Globals.COLORS[p.colour][1]/255.0,Globals.COLORS[p.colour][2]/255.0)
			count+=1
	chart_node.initialize(p_dict)
	
	reset()
	set_process(true)
