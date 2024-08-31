extends Node2D

# Size of the screen or viewport (example values)
@export var screen_width: int = 1024
@export var screen_height: int = 768

# Number of spike traps to spawn
@export var spike_count: int = 5

# Spike trap scene to instance
@export var spike_scene: PackedScene
var level: int = 0
@export var easy_mode = true
var rng = RandomNumberGenerator.new()

func generate_level() -> void:
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
		var y = spike_rng.randf_range(0, screen_height)
		var spike = spike_scene.instantiate()
		spike.position = Vector2(x, y)
		$spikes.add_child(spike)

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

func _on_timer_timeout() -> void:
	generate_level()
	
func toggle_mode():
	easy_mode = !easy_mode
	generate_level()
	
func respawn_player():
	$player.position = $spawn.position
	
	
func next_level() -> void:
	respawn_player()
	level+=1 # = rng.randi_range(0, 11)
	generate_level()

func _endzone_entered(body: Node2D) -> void:
	if (body.name == "player"):
		next_level()

func _backwall_entered(body: Node2D) -> void:
	if (body.name == "player"):
		respawn_player()
		generate_level()
