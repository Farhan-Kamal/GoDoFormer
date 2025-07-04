extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -600.0
var pick_ups = 0
var deaths = 0

signal update_score(score:int)
signal update_death(death:int)

func _ready():
	pick_ups = Global.global_pickups
	deaths = Global.global_death

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		if is_on_floor():
			if direction == 1:
				$AnimatedSprite2D.flip_h = false
			else:
				$AnimatedSprite2D.flip_h = true
			$AnimatedSprite2D.play(&"walk")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if is_on_floor():
			$AnimatedSprite2D.play("idle")
			
		# Handle jump.
	if Input.is_action_just_pressed(&"jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		$AnimatedSprite2D.play(&"jump")
		$AnimatedSprite2D.play(&"fall")
		
	move_and_slide()

func respawn():
	get_tree().change_scene_to_file("res://level1.tscn")

func _on_void_zone_body_entered(body: Node2D) -> void:
	deaths += 1
	Global.global_death += deaths
	respawn()
func _on_sides_body_entered(body: Node2D) -> void:
	deaths += 1
	Global.global_death += deaths
	respawn()


func _on_land_enemy_squashed(node: Node) -> void:
	velocity.y = JUMP_VELOCITY
	print("RAW MUSTARD")


func _on_pickup_body_entered(body: Node2D) -> void:
	pick_ups += 1
	update_score.emit(pick_ups)
	print(pick_ups)
	Global.global_pickups = pick_ups


func _on_exit_body_entered(body: Node2D) -> void:
	get_tree().change_scene_to_file("res://level2.tscn")
	print("HELP")
