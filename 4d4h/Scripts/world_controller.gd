extends Node

var inverted := false
var gravity := true
var gravityTimer : float = 0.0
@export var gravityTimeLimit : float = 5.0
@export var can_ungravite := true
@export var can_invert := true
@export var startInvert := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("worldsFinishing")
	if startInvert:
		await get_tree().create_timer(0.01).timeout
		inverted = !inverted
		get_tree().call_group("reacts_to_inversion", "on_invert", inverted)
		
func on_end():
	if not inverted:
		inverted = !inverted
		get_tree().call_group("reacts_to_inversion", "on_invert", inverted)
	await get_tree().create_timer(2.0).timeout
	var actualScene : String = get_tree().current_scene.name
	print(str(int(actualScene) + 1))
	if actualScene == "Mundo":
		get_tree().change_scene_to_file("res://scenes/worlds/level1.tscn")
	else:
		get_tree().change_scene_to_file("res://scenes/worlds/level" + str(int(actualScene) + 1) + ".tscn")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("toggle_world") and can_invert:
		inverted = !inverted
		get_tree().call_group("reacts_to_inversion", "on_invert", inverted)
	if gravity:
		if Input.is_action_just_pressed("gravity_world") and can_ungravite:
			gravity = false
			get_tree().call_group("reacts_gravity", "on_ungravited", gravity)
	else:
		gravityTimer += delta
		if gravityTimer > gravityTimeLimit or Input.is_action_just_pressed("gravity_world"):
			gravity = true
			gravityTimer = 0
			get_tree().call_group("reacts_gravity", "on_ungravited", gravity)
