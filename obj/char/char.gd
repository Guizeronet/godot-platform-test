extends KinematicBody2D

export (int) var speed = 120 * 2
export (int) var jump_speed = -180 * 1.5
export (int) var gravity = 400

var velocity = Vector2.ZERO

var initial_position = null

# Called when the node enters the scene tree for the first time.
func _ready():
	initial_position = position
	pass # Replace with function body.

var play_platform_audio = false
var frist_touch_in_platform = false

func get_input():
	velocity.x = 0
	if Input.is_action_pressed("ui_right"):
		velocity.x += speed
	if Input.is_action_pressed("ui_left"):
		velocity.x -= speed

func _physics_process(delta):
	get_input()
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, Vector2.UP)
	
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if collision.collider.is_in_group("platform") and play_platform_audio == true:
			play_platform_audio = false
			get_node("AudioStreamPlayer").play()
			pass
		elif collision.collider.is_in_group("die"):
			position = initial_position
			pass
	
	if Input.is_action_just_pressed("ui_up"):
		if is_on_floor():
			velocity.y = jump_speed
	
	if not is_on_floor() and play_platform_audio == false and frist_touch_in_platform == true:
		play_platform_audio = true
	
	if is_on_floor() and frist_touch_in_platform == false:
		frist_touch_in_platform = true
