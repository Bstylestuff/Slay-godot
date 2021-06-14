extends Node

var hosting=false
var joining=false
var url="http://bstylestuff.com/slay_app/main.php"
var headers=["Content-Type: application/x-www-form-urlencoded"]

var use_ssl=false
var server_id=0
var games=[]
var server_item
var waiting=false
var checking=false


func _ready():
	var response = PlayerData.Load()
	if response =="Fresh Blewd":
		$New_Player_Dialog.popup()

func quit():
	get_tree().quit()

func Host():
	#Basically, when you press on host, it means you don't want to join, so: 
	#1-> hide everything related to joining and disable them
	#2-> open the server info pop-up
	#      > when they click on confirm in that pop-up, you start _on_Confirm_Server_Data_pressed()
	#$Control/Button_START.disabled=false
	#$Control/Button_START.visible=true
	#$Control/Button_JOIN.disabled=true
	#$Control/Button_JOIN.visible=false
	hosting=true
	joining=false
	$HostDialogue.popup_centered()


func start_hosting():
	#First hide the dialog, then start gathering data from what the user said
	#$Server_data_Dialog.hide()
	var user_name=PlayerData.Player_Name
	var spectator=1#$Server_data_Dialog/VBoxContainer/HBoxContainer5/Spectator_Toggle.is_pressed()
	var max_players=5#int($Server_data_Dialog/VBoxContainer/HBoxContainer3/Max_Player_text.text)
	if spectator:
		spectator=1
	else:
		spectator=0
	#Create a dictionary with all the data we send to the server via the HTTP request
	var fields={
	'Host_Name': user_name,
	'function': "Add_Server",  
	'Spectator': spectator, 
	'Max_Player':max_players, 
	'Port':pick_port()
	}
	#Create an HTTP client in order to turn the request into the data we need to send (it can also be done manually, but meh, not pretty)
	var http = HTTPClient.new() 
	#note the current player
	set_player_info()
	#Actually create a query text from the fields
	var query_string = http.query_string_from_dict(fields)
	#Send the request to our DB
	$HTTPRequest.request(url, headers, use_ssl, HTTPClient.METHOD_POST, query_string)
	print("Hosting network")
	#Set the info for our actual game server
	#the_matrix.server_info.name = game_name
	#the_matrix.server_info.max_players = max_players
	#the_matrix.server_info.used_port = port
	#the_matrix.server_info.game_type = game_type
	#the_matrix.server_info.spectator = spectator
	
	# And create the server
	#the_matrix.create_server()
	#Now we wait for clients




func _on_HTTPRequest_request_completed(result, response_code, headers, body ):
	#Decode the data
	print(body.get_string_from_utf8())
	
	var json = JSON.parse(body.get_string_from_utf8())
	var api_response = (json.result)
	#rint(api_response)
	#If we are hosting, then check if it worked
	print("CheckifHosting")
	if hosting==true:
		if (validate_json(body.get_string_from_utf8())==""):
			print("HOSTINGTRU")
			#If checking for new players for the list
			if checking==false:
				print("ADDINGSRV")
				if(api_response["result"]=="Added server!"):
					pass
					#If so, set our id to the one in the DB (useful for when we want to close it)
			#		the_matrix.server_info.ID=api_response["ID"]
			#		the_matrix.create_server()
			#		_start_loading()
			#else:
				#TODO: Add new players in list and ping them all
			#	server_item=preload("res://Objects/UI/Server_List_Item.tscn")
			#	for game in api_response['clients']:
			#		var item = server_item.instance()
			#		item.get_node("Label_name").text=game['Name']
			#		item.get_node("Label_amount").text=game["IP_Address"]
			#		item.get_node("Button").connect("pressed", self, "join_server", [game["ID"], game["IP_Address"], game["Port"]])
			#		$output_list.add_child(item)
	else:
		#If we want to join, check the games we got
		if joining==true:
			if(api_response!=null):
				if(api_response["result"]=="Perfect!"):
					for game in api_response["games"]:
						games.append(game)
					#populate_list("games")
		
	







func pick_port():
	randomize()
	var port=randi()%33532+32000
	return port

func set_player_info():
	#TODO
	pass
	

func Join():
	pass

func _on_Quit_Button_pressed():
	get_tree().quit()

func _on_Host_Button_pressed():
	$host_menu_Dialog.popup_centered()

func _on_Join_Button_pressed():
	#pass
	Globals.goto_scene("res://scenes/objects/game/gameScene.tscn")


func _on_Enter_Name_Button_pressed():
	PlayerData.add_Player($New_Player_Dialog/VBoxContainer/HBoxContainer/Player_Name_TextEdit.text)
	$New_Player_Dialog.hide()
	


func _on_Enter_Name_UIButton_pressed():
	_on_Enter_Name_Button_pressed()


func _on_JoinUI_pressed():
	_on_Join_Button_pressed()


func _on_start_hosting_button_pressed():
	start_hosting()


func _on_Button_pressed():
	_on_start_hosting_button_pressed()


func _on_Button2_pressed():
	_on_Host_Button_pressed()
