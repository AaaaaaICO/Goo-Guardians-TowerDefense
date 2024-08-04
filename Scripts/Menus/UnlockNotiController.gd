
extends Control


var msg

func _ready():
	get_node("AnimationPlayer").play("Reveal")
	get_node("CPUParticles2D").set_emitting(true)
	get_node("ColorRect/MarginContainer/Control/LBL_Message").set_text(msg)


