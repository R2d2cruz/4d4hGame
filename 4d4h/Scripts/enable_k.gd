extends Area2D

@onready var collisionShape2D := $CollisionShape2D
@onready var worldController := get_parent().get_node("WorldController")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if body.get_name() == "Player":
		worldController.can_invert = true
