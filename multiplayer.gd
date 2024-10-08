extends Node2D

# Networking
var peer = ENetMultiplayerPeer.new()
@export var player_name = "Player"
@export var player_placeholder: PackedScene
var positions = {}
var connected = false

func _ready():
	multiplayer.peer_connected.connect(self._player_connected)
	multiplayer.peer_disconnected.connect(self._player_disconnected)
	multiplayer.connected_to_server.connect(self._connected_ok)
	multiplayer.connection_failed.connect(self._connected_fail)
	multiplayer.server_disconnected.connect(self._server_disconnected)

	var args = OS.get_cmdline_args()
	if "--server" in args or OS.has_feature("server"):
		host_game()
	else:
		join_game()

func host_game():
	peer.create_server(4242)
	multiplayer.multiplayer_peer = peer
	print("Waiting for players!")

func join_game():
	if (OS.is_debug_build()):
		peer.create_client("localhost", 4242)
	else:
		peer.create_client("66.225.102.10", 4242)
	multiplayer.multiplayer_peer = peer

func _player_connected(id):
	print("Player connected: " + str(id))
#
	var p = player_placeholder.instantiate()
	p.pname = str(id)
	p.position = Vector2(640, 480)
	p.name = str(id)
	$net_players.add_child(p, true)
	$"../".respawn_player() # may want to make more granular call to update level only

func _player_disconnected(id):
	for i in $net_players.get_children():
		if i.name == str(id):
			$net_players.remove_child(i)
			i.queue_free()
	print("Player disconnected: " + str(id))

func _connected_ok():
	connected = true
	print("Connected to server!")

func _connected_fail():
	connected = false
	print("Connection failed!")

func _server_disconnected():
	connected = false
	print("Server disconnected!")

@rpc("any_peer", "call_local")
func update_position(pos):
	var sender_id = multiplayer.get_remote_sender_id()
	positions[sender_id] = pos
	
	for i in $net_players.get_children():
		if i.name == str(sender_id):
			i.position = pos

@rpc("any_peer", "call_local")
func update_level(level):
	var sender_id = multiplayer.get_remote_sender_id()
	
	for i in $net_players.get_children():
		if i.name == str(sender_id):
			i.level = level

@rpc("any_peer", "call_local")
func update_mode(easy_mode):
	var sender_id = multiplayer.get_remote_sender_id()
	
	for i in $net_players.get_children():
		if i.name == str(sender_id):
			i.easy_mode = easy_mode

@rpc("any_peer", "call_local")
func update_name(name):
	var sender_id = multiplayer.get_remote_sender_id()
	
	for i in $net_players.get_children():
		if i.name == str(sender_id):
			i.pname = name
