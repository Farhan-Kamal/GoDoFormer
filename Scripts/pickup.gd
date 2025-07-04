extends Area2D

@export var player : Node

func _ready():
	if player:
		body_entered.connect(player._on_pickup_body_entered)
		

func _on_body_entered(body: Node2D) -> void:
	queue_free()
