extends CharacterBody2D

const moveSpeed := 50
const speedGravityLost = -15
var gravity_enabled := true
var direction := 0
@onready var collisionShape2D := $CollisionShape2D

func _ready():
	add_to_group("reacts_gravity")
	add_to_group("pushable")

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
