extends CharacterBody3D

@export var speed = 14
@export var fall_acceleration = 75
@export var jump_impulse = 20
@export var bounce_impulse = 16

var target_velocity = Vector3.ZERO

signal hit

#var move_map = {
#	"move_right": ['x',1],
#	"move_left": ["x", -1],
#	"move_up": ['z', 1],
#	"move_down" : ['z', -1]
#}


func _physics_process(delta):
	# Local variable stores the input direction.
	var direction = Vector3.ZERO
	
	# if Input.is_action_pressed("jump"):
		#direction.y += 1     should it be 1? idk
	
	# We check for each move input and update the direction accordingly.
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_back"):
		direction.z += 1
	if Input.is_action_pressed("move_forward"):
		direction.z -= 1
	
	if direction != Vector3.ZERO:
		direction = direction.normalized()
		$Pivot.basis = Basis.looking_at(direction)
		
	# Ground Velocity
	target_velocity.x = direction.x * speed
	target_velocity.z = direction.z * speed
	
	# Vertical Velocity: Gravity.
	if not is_on_floor(): # These two lines make gravity happen in our game!
		target_velocity.y = target_velocity.y - (fall_acceleration * delta)
	
	# Add some vertical velocity when we press jump!
	# It will decrease on its own due to gravity being coded in above.
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		target_velocity.y = jump_impulse
	
	# Iterate through all collisions that occurred this frame
	for index in range(get_slide_collision_count()):
		# We get one of the collisions with the player
		var collision = get_slide_collision(index)
		
		# If the collision is with ground
		if collision.get_collider() == null:
			continue

		# If the collider is with a mob
		if collision.get_collider().is_in_group("mob"):
			var mob = collision.get_collider()
			# we check that we are hitting it from above.
			if Vector3.UP.dot(collision.get_normal()) > 0.1:
				# If so, we squash it and bounce.
				mob.squash()
				target_velocity.y = bounce_impulse
				# Prevent further duplicate calls.
				break
				
	# Moving the character
	velocity = target_velocity
	move_and_slide()

func die():
	hit.emit()
	queue_free()

func _on_mob_detector_body_entered(body: Node3D) -> void:
	die()
