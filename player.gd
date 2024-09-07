extends CharacterBody2D

# Speed of the player
@export var speed: float = 200.0
# Gravity to apply to the player
@export var gravity: float = 800.0
# Jump force
@export var jump_velocity: float = -400.0
var last_restart_time: float = 0.0
@export var fast_fall_multiplier: float = 2.7
@export var level: Node2D
var mp: Node
var arguments = {}

func _ready() -> void:
	mp = $"../multiplayer"
	for argument in OS.get_cmdline_args():
		if argument.contains("="):
			var key_value = argument.split("=")
			arguments[key_value[0].trim_prefix("--")] = key_value[1]
		else:
			# Options without an argument will be present in the dictionary,
			# with the value set to an empty string.
			arguments[argument.trim_prefix("--")] = ""

func _physics_process(delta):
	var args = OS.get_cmdline_args()
	if arguments.has("server") or OS.has_feature("server"):
		return
	
	if mp.connected:
		mp.update_position.rpc(position)
	# Get the input direction
	var direction: Vector2 = Vector2.ZERO
	
	if Input.is_action_just_pressed("place_platform"):
		level.place_platform(get_global_mouse_position())

	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1

	if Input.is_action_pressed("fall_faster"):
		velocity.y += gravity * fast_fall_multiplier * delta
	else:
		velocity.y += gravity * delta

	# Check if the player is on the ground and the jump button is pressed
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y = jump_velocity

	# Apply movement
	velocity.x = direction.x * speed
	move_and_slide()

	if get_slide_collision_count() > 0:
		for i in range(get_slide_collision_count()):
			var collision = get_slide_collision(i)
			if(collision.get_collider().name.begins_with('spike')):
				var current_time = Time.get_ticks_msec() / 1000.0
				if current_time - last_restart_time > 1.0:
					hit_by_spike()
					last_restart_time = current_time
				break

	# Quit the game if "Q" is pressed
	if Input.is_action_just_pressed("quit_game"):
		get_tree().quit()

func hit_by_spike():
	if (!level.easy_mode):
		level.level = 0
	level.respawn_player()
	level.generate_level()
