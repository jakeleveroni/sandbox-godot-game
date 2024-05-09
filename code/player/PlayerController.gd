extends CharacterBody2D

@export var speed: int = 155
@export var time_to_jump_peak: float = 0.35
@export var jump_height: int = 45
@export var jump_buffer_time: float = 0.1

var _gravity: float
var _jump_speed: float 
var _jump_buffered: bool = false
var _jump_available: bool = false

func _ready():
	# calculations based on gdc talk building a better jump (practical application): https://www.youtube.com/watch?v=fE8f5-ZHD_k	
	_gravity = (2 * jump_height) / pow(time_to_jump_peak, 2)	
	_jump_speed = _gravity * time_to_jump_peak

func _physics_process(delta):
	var direction = Input.get_axis("Left", "Right")
	
	apply_movement(direction)
	apply_rotate(direction)
	
	if Input.is_action_just_pressed("Jump"):
		apply_jumping(delta)
	
	if is_on_floor() and _jump_buffered:
		apply_jumping(delta)
	
	apply_gravity(direction, delta)

func apply_movement(direction: int):
	if direction:
		velocity.x = direction * speed
		safe_play_animation("Run")
	else:
		velocity.x = 0
		safe_play_animation("Idle")
		
	move_and_slide()
	
	# check if on floor after move_and_slide
	_jump_available = is_on_floor()


func apply_rotate(direction: int):
	if direction == 1:
		$AnimatedSprite2D.flip_h = false
	elif direction == -1:
		$AnimatedSprite2D.flip_h = true
	
func apply_jumping(delta: float):
		if _jump_available:
			_jump_available = false
			velocity.y -= _jump_speed
			$AnimatedSprite2D.play("Jump")
		else:
			_jump_buffered = true
			get_tree().create_timer(jump_buffer_time).timeout.connect(on_jump_buffer_timeout)
				
func apply_gravity(direction: int, delta: float):
	if not is_on_floor():
		velocity.y += _gravity * delta
		$AnimatedSprite2D.play("Fall")

func safe_play_animation(animation: String):
	if is_on_floor():
		$AnimatedSprite2D.play(animation)

func on_jump_buffer_timeout():
	_jump_buffered = false
