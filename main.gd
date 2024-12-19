extends Node
@export var mob_scene: PackedScene


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_mob_timer_timeout() -> void:
	# Instanstiate a mob scene so that we actually have a mob.
	var mob = mob_scene.instantiate()
	
	# Get a location on the path by grabbing the path and moving randf() % of the way there.
	var mob_spawn_location = get_node("SpawnPath/SpawnLocation")
	mob_spawn_location.progress_ratio = randf()
	
	# Call the init func for the mob with the player's position and the generated position on the path.
	var player_position = $Player.position
	mob.initialize(mob_spawn_location.position, player_position)
	
	# Finally, add it to the main scene!
	add_child(mob)
	
	mob.squashed.connect($UserInterface/ScoreLabel._on_mob_squashed.bind())


func _on_player_hit() -> void:
	$MobTimer.stop()
