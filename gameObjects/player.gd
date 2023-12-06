extends CharacterBody3D

signal hit

@export var jump_impulse = 20
@export var bounce_impulse = 16

const SPEED = 14.0
const FALL_SPEED = 75
var target_velocity = Vector3.ZERO

func _physics_process(delta):
	var direction = Vector3.ZERO
	

	
	if Input.is_action_pressed("move_right"):
		direction.x +=1
	if Input.is_action_pressed("move_left"):
		direction.x -=1
	if Input.is_action_pressed("move_forward"):
		direction.z -=1
	if Input.is_action_pressed("move_back"):
		direction.z +=1

	if direction != Vector3.ZERO:
		$Pivot.look_at(position + direction, Vector3.UP)
		$AnimationPlayer.speed_scale = 4
	else:
		$AnimationPlayer.speed_scale = 1
		
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		target_velocity.y = jump_impulse
	collision_loop()
		
	target_velocity.x = direction.x * SPEED
	target_velocity.z = direction.z * SPEED
	
	if not is_on_floor():
		target_velocity.y = target_velocity.y - (FALL_SPEED * delta)
		
	velocity = target_velocity
	move_and_slide()
	$Pivot.rotation.x = PI / 6 * velocity.y / jump_impulse
	
func collision_loop():
	for index in range(get_slide_collision_count()):
		var collision = get_slide_collision(index)

		if collision.get_collider() == null:
			continue

		if collision.get_collider().is_in_group("mob"):
			var mob = collision.get_collider()
			if Vector3.UP.dot(collision.get_normal()) > 0.1:
				mob.squash(position)
				target_velocity.y = bounce_impulse
				break


func _on_mob_detector_body_entered(body):
	die()
		
func die():
	hit.emit()
	queue_free()
