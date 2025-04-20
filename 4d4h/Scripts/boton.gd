extends StaticBody2D

@onready var sprite2D = $Sprite2D
@onready var collisionShape2D : CollisionPolygon2D = $CollisionShape2D
@onready var rayCast2D = $RayCast2D

@export var when_appers := 0 #0 ambos, 1 normal, 2 invertido
@export var code := 0

var frame := 0
var active := true
var inversed := false
var frames := {
	false: {
		true: 3,
		false: 0,
	},
	true: {
		true: 7,
		false: 4,
	}
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("reacts_to_inversion")
	sprite2D.frame = frame
	sprite2D.visible = when_appers == 0 or when_appers == 1
	collisionShape2D.disabled = when_appers == 2

# Called every frame. 'delta' is the elapsed time since the previous frame.
func on_invert(state: bool):
	active = state == (when_appers == 2) or (when_appers == 0)
	sprite2D.visible = active
	collisionShape2D.disabled = not active
	inversed = state


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var collision = rayCast2D.is_colliding()
	sprite2D.frame = frames[inversed][collision]
	
	get_tree().call_group("boton_controlled", "on_button", code, active and collision)
