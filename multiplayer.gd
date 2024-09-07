extends Node2D

# Networking
var peer = ENetMultiplayerPeer.new()
@export var player_name = "Player"
@export var player_placeholder: PackedScene
var positions = {}

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
	peer.create_client("localhost", 4242)
	multiplayer.multiplayer_peer = peer

func _player_connected(id):
	print("Player connected: " + str(id))
	var p = player_placeholder.instantiate()
	p.position = Vector2(640, 480)
	p.name = str(id)
	$net_players.add_child(p)

func _player_disconnected(id):
	print("Player disconnected: " + str(id))

func _connected_ok():
	print("Connected to server!")

func _connected_fail():
	print("Connection failed!")

func _server_disconnected():
	print("Server disconnected!")

@rpc("any_peer", "call_local")
func update_position(pos):
	var sender_id = multiplayer.get_remote_sender_id()
	positions[sender_id] = pos
	for i in $net_players.get_children():
		if i.name == str(sender_id):
			i.position = pos
