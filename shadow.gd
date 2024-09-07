extends Node2D
@export var pname = "placeholder"
@export var level = 0
@export var easy_mode: bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$Label.text = pname
	visible = $"../../../".level == level
	pass
