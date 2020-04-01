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

var play_platform_audio = false # Save the audio state
var frist_touch_in_platform = false # Prevent to play the sound on startup of game

# Handle input
func get_input():
	velocity.x = 0
	if Input.is_action_pressed("ui_right"):
		velocity.x += speed
	if Input.is_action_pressed("ui_left"):
		velocity.x -= speed

# Process the moviment logic
func _physics_process(delta):
	get_input()
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, Vector2.UP)
	
	# Get colisions for move_and_slide function
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		
		# verify if the character is coliding with a platform and if the audio isn't played
		if collision.collider.is_in_group("platform") and play_platform_audio == true:
			play_platform_audio = false
			get_node("AudioStreamPlayer").play()
			pass
		elif collision.collider.is_in_group("die"):
			position = initial_position
			pass
	
	if Input.is_action_just_pressed("ui_up"):
		# is_on_floor function can only be used with move_and_slide
		if is_on_floor():
			velocity.y = jump_speed
	
	# reset the audio state if the character is not on floor and the first touch has happened
	if not is_on_floor() and play_platform_audio == false and frist_touch_in_platform == true:
		play_platform_audio = true
	
	# save the state of the first touch in a platform
	if is_on_floor() and frist_touch_in_platform == false:
		frist_touch_in_platform = true
