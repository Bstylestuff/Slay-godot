extends Node


var Players=[]
var time=0

func Next_Turn():
	#Ends current player turn, sends to server 
	#If server, updates everyone on last turn and sends the turn to the next one
	pass

func add_player(player):
	Players.append(player)
	
func prepare_game():
	#Mixup the list of players
	
	Players.shuffle()
	var player_spaces=[]
	var player_counter=0
	for player_index in len(Players):
		var slant_amount=player_index+1
		while slant_amount>0:
			player_spaces.append(Players[player_index])
			slant_amount=slant_amount-1
	
	
		
		
	
	#then make the actual game board, with randomness slanted based on player turn count,
	#IE first player gets least amount of starting areas, last player gets the most
	
	#draw it
