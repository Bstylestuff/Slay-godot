extends Control

onready var chart_node = get_node('chart')

func _ready():
  chart_node.initialize(
  {
	player1 = Color(1.0, 0.58, 0.68),
	player2 = Color(0.58, 0.92, 0.07),
	player3 = Color(0.5, 0.22, 0.6),
	player4 = Color(0.1, 0.82, 0.6)
  })

  reset()
  set_process(true)


func reset():
  chart_node.create_new_point({
	values = {
	  player1 = 150,
	  player2 = 1025,
	  player3 = 1050,
	  player4=600
	}
  })

 
