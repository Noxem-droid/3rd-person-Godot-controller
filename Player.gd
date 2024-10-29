extends CharacterBody3D

@onready var head = $head

@onready var FOV = $head/Camera



var play = true

@export var SPEED = 5.0

@export var gravity = 10

@export var DIRECTION = 5.0
@export var walk = 6.0
@export var sprinting = 8.0
@export var crouching = 3.0
@export var S_ONAIR = 7.3

@export var JUMP_VELOCITY = 3.5

@export var sensitivity = 0.1
@export var acceleration = 1.07

func _ready(): 
	
	FOV.current = true
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _input(event):
	
	if play:
		if event is InputEventMouseMotion:
			rotate_y(deg_to_rad(-event.relative.x * sensitivity) * acceleration)
			$head.rotate_x(deg_to_rad((-event.relative.y * sensitivity) * acceleration))
			$head.rotation.x = clamp(head.rotation.x,deg_to_rad(-45),deg_to_rad(35))
			
func _process(_delta):
	
	if Input.is_action_just_pressed("exit"):
		get_tree().quit() 
	if play:
		if Input.is_action_just_pressed("restart"):
			restart()				
		if position.y < -4:
			restart()
			
func _physics_process(delta):
	if play:
		
		
		
		if Input.is_action_pressed("Sprinting"):
			SPEED = sprinting
	

		
		else:
			SPEED = walk
		
		if is_on_floor():
			gravity = 15
			velocity.y = 0
		
	
	# Add the gravity.
		if not is_on_floor():
			if velocity.y < 0:
				gravity = gravity + JUMP_VELOCITY / 8
			velocity.y -= gravity * delta
			SPEED = S_ONAIR
		
		 
		
			

	# Handle jump.
		while Input.is_action_pressed("jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY
			break

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	
		var input_dir = Input.get_vector("left", "right", "up", "down")
		var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		if direction :
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)

		move_and_slide()

func restart():
	get_tree().reload_current_scene()


