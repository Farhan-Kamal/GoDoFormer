extends CanvasLayer

func _ready() -> void:
	$score.text = str(Global.global_pickups)

func _on_player_update_score(score: int) -> void:
	$score.text = str(score)
