extends CharacterBody3D

@export var min_speed = 10
@export var max_speed = 18

signal squashed

func _physics_process(_delta):
	move_and_slide()

func initialize(start_position, player_position):
	# Defines where the mob is looking: at the player.
	look_at_from_position(start_position, player_position, Vector3.UP)
	
	# Rotate slightly at random.
	rotate_y(randf_range(-PI/4, PI/4))
	
	# Get a random speed within the bounds.
	var random_speed = randi_range(min_speed, max_speed)
	
	# Set the velocity vector with that speed and rotate it according to the way
	#   the mob is looking from the above code.
	velocity = Vector3.FORWARD * random_speed
	velocity = velocity.rotated(Vector3.UP, rotation.y)
	
	
func squash():
	squashed.emit()
	queue_free()

func _on_visible_on_screen_notifier_3d_screen_exited() -> void:
	queue_free()
