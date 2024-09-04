extends Node2D

# Size of the screen or viewport (example values)
@export var screen_width: int = 1024
@export var screen_height: int = 768

# Number of spike traps to spawn
@export var spike_count: int = 12

# Spike trap scene to instance
@export var spike_scene: PackedScene
var level: int = 72
@export var easy_mode = false
var rng = RandomNumberGenerator.new()

# Platform scene and management
@export var platform_scene: PackedScene
var platforms = []
const MAX_PLATFORMS = 5
const generation_speed = 2.0

func generate_level() -> void:
	$Timer.wait_time = generation_speed;
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

func _ready() -> void:
	rng.seed = level
	next_level()
	
func _input(e: InputEvent):
	if (OS.is_debug_build()):
		if (e.is_action_pressed("next_level")):
			level = mini(11, level + 1)
			generate_level()
		if (e.is_action_pressed("prev_level")):
			level = maxi(0, level - 1)
			generate_level()
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
	
func respawn_player():
	$player.position = $spawn.position
	var current_time = Time.get_ticks_msec() / 1000.0
	$player.last_restart_time = current_time
	
	
func next_level() -> void:
	respawn_player()
	reset_platforms()
	level += 1
	generate_level()

func _endzone_entered(body: Node2D) -> void:
	if (body.name == "player"):
		next_level()

func _backwall_entered(body: Node2D) -> void:
	if (body.name == "player"):
		respawn_player()
		generate_level()

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
