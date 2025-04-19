extends CharacterBody2D

const moveSpeed = 50
const maxSpeed = 100
const jumpHeight = -350
const gravity = 15
const speedGravityLost = -15
const timeEyes = 4;

@onready var sprite = $Sprite2D
@onready var animationPlayer = $AnimationPlayer
var timerEyes : float = 0;
var playing_idle2 := false
var gravity_enabled := true

func _ready():
	add_to_group("reacts_gravity")

func on_ungravited(state: bool):
	print("player gravity")
	gravity_enabled = state

func _physics_process(_delta):
	var friction = false
	if gravity_enabled:
		velocity.y += gravity

		if Input.is_action_pressed("ui_right"):
			sprite.flip_h = false
			animationPlayer.play("Walk")
			velocity.x = min(velocity.x + moveSpeed, maxSpeed)

		elif Input.is_action_pressed("ui_left"):
			sprite.flip_h = true
			animationPlayer.play("Walk")
			velocity.x = max(velocity.x - moveSpeed, -maxSpeed)

		else:
			timerEyes += _delta
			if timerEyes > timeEyes:
				animationPlayer.play("Idle_2")
				playing_idle2 = true
				if timerEyes > timeEyes + 0.6:
					timerEyes = 0
			else:
				animationPlayer.play("Idle")
			friction = true

		if is_on_floor():
			if Input.is_action_pressed("ui_accept"):
				velocity.y = jumpHeight
			if friction:
				velocity.x = lerp(velocity.x, 0.0, 0.5)
		else:
			if friction:
				velocity.x = lerp(velocity.x, 0.0, 0.01)
				
	else:
		velocity.y = speedGravityLost
		if is_on_ceiling():
			if Input.is_action_pressed("ui_right"):
				sprite.flip_h = false
				animationPlayer.play("Walk")
				velocity.x = min(velocity.x + moveSpeed, maxSpeed)

			elif Input.is_action_pressed("ui_left"):
				sprite.flip_h = true
				animationPlayer.play("Walk")
				velocity.x = max(velocity.x - moveSpeed, -maxSpeed)
				
			else:
				timerEyes += _delta
				if timerEyes > timeEyes:
					animationPlayer.play("Idle_2")
					playing_idle2 = true
					if timerEyes > timeEyes + 0.6:
						timerEyes = 0
				else:
					animationPlayer.play("Idle")
				friction = true
				if friction:
					velocity.x = lerp(velocity.x, 0.0, 0.5)
		else:
			if friction:
				velocity.x = lerp(velocity.x, 0.0, 0.01)

	move_and_slide()
