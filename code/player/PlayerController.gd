extends CharacterBody2D

@export var SPEED = 155.0
@export var GRAVITY = 900
@export var JUMP_FORCE = 255

@export var time_to_jump_peak = 0.35
@export var jump_height = 45

var _gravity: float
var _jump_speed: float 

func _ready():
	# calculations based on gdc talk building a better jump (practical application): https://www.youtube.com/watch?v=fE8f5-ZHD_k	
	# calculate gravity
	_gravity = (2 * jump_height) / pow(time_to_jump_peak, 2)
	
	# calculate jump speed based on gravity
	_jump_speed = _gravity * time_to_jump_peak

func _physics_process(delta):
	var direction = Input.get_axis("Left", "Right")
	
	apply_movement(direction)
	apply_rotate(direction)
	
	apply_jumping(delta)
	
	apply_gravity(direction, delta)

func apply_movement(direction: int):
	if direction:
		velocity.x = direction * SPEED
		safe_play_animation("Run")
	else:
		velocity.x = 0
		safe_play_animation("Idle")
		
	move_and_slide()

func apply_rotate(direction: int):
	if direction == 1:
		$AnimatedSprite2D.flip_h = false
	elif direction == -1:
		$AnimatedSprite2D.flip_h = true
	
func apply_jumping(delta: float):
	if Input.is_action_just_pressed("Jump") and is_on_floor():	
		velocity.y -= _jump_speed
		$AnimatedSprite2D.play("Jump")
	
func apply_gravity(direction: int, delta: float):
	if not is_on_floor():
		velocity.y += _gravity * delta
		$AnimatedSprite2D.play("Fall")

func safe_play_animation(animation: String):
	if is_on_floor():
		$AnimatedSprite2D.play(animation)
