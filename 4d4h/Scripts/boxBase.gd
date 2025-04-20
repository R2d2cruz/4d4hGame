extends CharacterBody2D

const moveSpeed := 50
const speedGravityLost = -15
var gravity_enabled := true
var direction := 0
@onready var collisionShape2D := $CollisionShape2D
@onready var sprite2D := $Sprite2D

@export var when_appers := 0 #0 ambos, 1 normal, 2 invertido
@export var code := 0
@export var frame := 3

var active := true
var frames:= {
	2: 7,
	3: 9,
	4: 8,
	5: 11,
	6: 10,
}

func _ready():
	add_to_group("reacts_gravity")
	add_to_group("pushable")
	add_to_group("reacts_to_inversion")
	sprite2D.frame = frames[frame]
	sprite2D.visible = when_appers == 0 or when_appers == 1
	collisionShape2D.disabled = when_appers == 2

# Called every frame. 'delta' is the elapsed time since the previous frame.
func on_invert(state: bool):
	active = state == (when_appers == 2) or (when_appers == 0)
	sprite2D.visible = active
	collisionShape2D.disabled = not active
	sprite2D.frame = frame if state else frames[frame]

func on_ungravited(state: bool):
	gravity_enabled = state


func _physics_process(delta: float) -> void:
	velocity.x = 0
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	if not gravity_enabled:
		velocity.y = speedGravityLost
		direction = 0
		
	velocity.x = direction * moveSpeed
	
	move_and_slide()
