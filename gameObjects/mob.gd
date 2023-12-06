extends CharacterBody3D
signal squashed
# Minimum speed of the mob in meters per second.
@export var min_speed = 10
# Maximum speed of the mob in meters per second.
@export var max_speed = 18

func initialize(start_position, player_position):
	
	var look_position = player_position
	look_position.y = 0
	look_at_from_position(start_position, look_position, Vector3.UP)
	rotate_y(randf_range(-PI / 4, PI / 4))
	var random_speed = randi_range(min_speed, max_speed)
	
	velocity = Vector3.FORWARD * random_speed
	
	velocity = velocity.rotated(Vector3.UP, rotation.y)

func _physics_process(_delta):
	move_and_slide()


func _on_visibility_notifier_screen_exited():
	queue_free()
	

func squash(pPos):
	print("Squashed!",pPos, position)
	
	squashed.emit()
	queue_free()
