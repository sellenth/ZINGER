extends Node2D

# Size of the screen or viewport (example values)
@export var screen_width: int = 1024
@export var screen_height: int = 768

# Number of spike traps to spawn
@export var spike_count: int = 12
@export var boulder_count: int = 3

# Spike trap scene to instance
@export var spike_scene: PackedScene
@export var boulder_scene: PackedScene
var level: int = 0
@export var easy_mode = false
var rng = RandomNumberGenerator.new()

# Platform scene and management
@export var platform_scene: PackedScene
var platforms = []
const MAX_PLATFORMS = 5
const generation_speed = 2.0

var ehiscore = 0
var echamp = "dmpdmp"
var hhiscore = 0
var hchamp = "dmpdmp"

func generate_level() -> void:
	$Timer.start()
	$level_text.text = str(level)
	$mode.text = "easy mode" if easy_mode else "hard mode"
	for n in $spikes.get_children():
		$spikes.remove_child(n)
		n.queue_free()
	
	var spike_rng = RandomNumberGenerator.new()
	spike_rng.seed = level
	
	# Generate spike traps
	for i in range(spike_count):
		var x = spike_rng.randf_range(0, screen_width)
		var y = spike_rng.randf_range(-200, 0)
		var spike = spike_scene.instantiate()
		spike.position = Vector2(x, y)
		$spikes.call_deferred("add_child", spike)

func generate_boulders() -> void:
	$Timer2.start()
	for n in $boulders.get_children():
		$boulders.remove_child(n)
		n.queue_free()
	
	var boulder_rng = RandomNumberGenerator.new()
	boulder_rng.seed = level + 1
	
	# Generate spike traps
	for i in range(boulder_count):
		var x = boulder_rng.randf_range(100, screen_width-100)
		var y = boulder_rng.randf_range(-100, 0)
		var boulder = boulder_scene.instantiate()
		boulder.position = Vector2(x, y)
		$boulders.call_deferred("add_child", boulder)

func _ready() -> void:
	rng.seed = level
	next_level()
	
func _input(e: InputEvent):
	if (OS.is_debug_build()):
		if (e.is_action_pressed("next_level")):
			next_level()
		if (e.is_action_pressed("prev_level")):
			level = maxi(0, level - 1)
			generate_level()
			generate_boulders()
	if (e.is_action_pressed("toggle_mode")):
		toggle_mode()
	if (e.is_action_pressed("clear")):
		platforms = []
		for n in $platforms.get_children():
			$platforms.remove_child(n)
			n.queue_free()

func _on_timer_timeout() -> void:
	generate_level()
	
func toggle_mode():
	easy_mode = !easy_mode
	respawn_player()
	generate_level()
	generate_boulders()
	
func respawn_player():
	$player.position = $spawn.position
	var current_time = Time.get_ticks_msec() / 1000.0
	$player.last_restart_time = current_time
	$multiplayer.update_level.rpc(level)
	$multiplayer.update_mode.rpc(easy_mode)
	
func next_level() -> void:
	level += 1
	respawn_player()
	reset_platforms()
	generate_level()
	generate_boulders()
	
func prev_level() -> void:
	level -= 1
	respawn_player()
	reset_platforms()
	generate_level()
	generate_boulders()

func _endzone_entered(body: Node2D) -> void:
	if (body.name == "player"):
		next_level()

func _backwall_entered(body: Node2D) -> void:
	if (body.name == "player"):
		respawn_player()
		generate_level()
		generate_boulders()

func place_platform(position):
	if len(platforms) < MAX_PLATFORMS:
		var platform = platform_scene.instantiate()
		platform.position = position
		$platforms.add_child(platform)
		platforms.append(platform)
	elif len(platforms) == MAX_PLATFORMS:
		var platform = platforms.pop_front()
		platform.position = position
		platforms.append(platform)

func reset_platforms():
	for platform in platforms:
		platform.queue_free()
	platforms.clear()


func _on_timer_2_timeout() -> void:
	generate_boulders()


func _on_refresh_scores_timer_timeout() -> void:
	for i in $"multiplayer/net_players".get_children():
		if (i.easy_mode && i.level > ehiscore):
			ehiscore = i.level
			echamp = i.name
		if (!i.easy_mode && i.level > hhiscore):
			hhiscore = i.level
			hchamp = i.name
	$easy_hiscore.text = "easy: " + str(ehiscore) + " - " + echamp
	$hard_hiscore.text = "hard: " + str(hhiscore) + " - " + hchamp
