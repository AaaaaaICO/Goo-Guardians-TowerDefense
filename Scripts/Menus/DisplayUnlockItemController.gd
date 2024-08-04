extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	var tween = get_tree().create_tween()
	tween.tween_property(get_node("ColorRect"), "position", Vector2(0,0), .2).set_trans(Tween.TRANS_QUINT)
	tween.parallel().tween_property(get_node("ColorRect"), "modulate", Color.WHITE, .05).set_trans(Tween.TRANS_QUINT)



