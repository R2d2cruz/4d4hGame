extends CharacterBody2D

const moveSpeed := 50
const maxSpeed := 100
const jumpHeight := -380
const gravity := 15
const speedGravityLost := -15
const timeEyes := 4;

@onready var sprite := $Sprite2D
@onready var animationPlayer := $AnimationPlayer
@onready var detectarCaja : RayCast2D = $DetectarCaja
@onready var light : PointLight2D = $PointLight2D
@onready var audio : = $AudioStreamPlayer2D

var timerEyes : float = 0;
var playing_idle2 := false
var gravity_enabled := true
var last_pushable : Node = null
var levelUnfinished := true
var was_on_floor := true

var audios := {
	"jump": load("res://Assets/Sounds/subida2.wav"),
	"fall": load("res://Assets/Sounds/caida.wav"),
	"walk": load("res://Assets/Sounds/walk.wav"),
}


func _ready():
	#add_to_group("reacts_gravity")
	add_to_group("reacts_to_inversion")
	add_to_group("worldsFinishing")
	light.enabled = false
	light.energy = 0
	var tween = create_tween()
	tween.tween_property(light, "energy", 0.6, 1.0)

func on_end():
	var tween = create_tween()
	tween.tween_property(light, "energy", 0.0, 1.5)


func on_invert(state: bool):
	light.enabled = state

func on_ungravited(state: bool):
	print("player gravity")
	gravity_enabled = state

func _physics_process(_delta):
	var friction = false
	if gravity_enabled:
		velocity += get_gravity() * _delta

		if Input.is_action_pressed("right"):
			sprite.flip_h = false
			detectarCaja.scale.x = 1
			velocity.x = min(velocity.x + moveSpeed, maxSpeed)
			if detectarCaja.is_colliding():
				animationPlayer.play("pushWalk")
			else:
				animationPlayer.play("newWalk")

		elif Input.is_action_pressed("left"):
			sprite.flip_h = true
			detectarCaja.scale.x = -1
			velocity.x = max(velocity.x - moveSpeed, -maxSpeed)
			if detectarCaja.is_colliding():
				animationPlayer.play("pushWalk")
			else:
				animationPlayer.play("newWalk")

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
		if detectarCaja.is_colliding():
			var collider = detectarCaja.get_collider()
			if collider.is_in_group("pushable"):
				collider.direction = Input.get_axis("left", "right")
				last_pushable = collider
		else:
			if last_pushable != null:
				last_pushable.direction = 0
				last_pushable = null

		if is_on_floor():
			was_on_floor = true
			if Input.is_action_pressed("ui_accept"):
				velocity.y = jumpHeight
				playSound("jump")
				was_on_floor = false
			if friction:
				velocity.x = lerp(velocity.x, 0.0, 0.5)
		else:
			if was_on_floor and (velocity.y > 0):
				playSound("fall")
				was_on_floor = false
			if friction:
				velocity.x = lerp(velocity.x, 0.0, 0.01)
				
	else:
		velocity.y = speedGravityLost
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

	move_and_slide()

func playSound(soundName):
	audio.stream = audios[soundName]
	audio.play()
	
