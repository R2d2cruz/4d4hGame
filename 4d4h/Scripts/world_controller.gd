extends Node

var inverted := false
var gravity := true
var gravityTimer : float = 0.0
@export var gravityTimeLimit : float = 5.0
@export var can_invert := true
@export var startInvert := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if startInvert:
		inverted = !inverted
		get_tree().call_group("reacts_to_inversion", "on_invert", inverted)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("toggle_world") and can_invert:
		inverted = !inverted
		get_tree().call_group("reacts_to_inversion", "on_invert", inverted)
	if gravity:
		if Input.is_action_just_pressed("gravity_world"):
			gravity = false
			get_tree().call_group("reacts_gravity", "on_ungravited", gravity)
	else:
		gravityTimer += delta
		if gravityTimer > gravityTimeLimit or Input.is_action_just_pressed("gravity_world"):
			gravity = true
			gravityTimer = 0
			get_tree().call_group("reacts_gravity", "on_ungravited", gravity)
