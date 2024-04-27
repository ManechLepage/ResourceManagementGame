extends CharacterBody2D

@export var max_speed : float
@export var acceleration : float


func _physics_process(delta):
	var direction : Vector2 = Input.get_vector("left", "right", "up", "down")
	
	velocity.x = move_toward(velocity.x, max_speed * direction.x, acceleration)
	velocity.y = move_toward(velocity.y, max_speed * direction.y, acceleration)
	
	move_and_slide()
