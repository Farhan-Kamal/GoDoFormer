extends CharacterBody2D

@export var direction = 1
@export var speed = 200.0
@export var player : Node
signal squashed(node:Node)

func _ready():
	# Make Enemy sprite go in a direction it's moving
	if direction == 1:
		$AnimatedSprite2D.flip_h = true
	else:
		$AnimatedSprite2D.flip_h = false
	if player:
		squashed.connect(player._on_land_enemy_squashed)
		$sides.body_entered.connect(player._on_sides_body_entered)

func _physics_process(delta: float) -> void:
		# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	#if direction == 1:
	#	velocity.x = speed
	#else:
	#	velocity.x = -speed
	velocity.x = direction * speed
	move_and_slide()




func _on_edge_marker_body_entered(body: Node2D) -> void:
	direction = -direction
	if direction == 1:
		$AnimatedSprite2D.flip_h = true
	else:
		$AnimatedSprite2D.flip_h = false

func _on_head_body_entered(body: Node2D) -> void:
	direction = 0
	squashed.emit(self)
	$AnimatedSprite2D.play("die")
	await $AnimatedSprite2D.animation_finished
	queue_free()
