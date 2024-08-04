extends CanvasLayer


func changeScene(target):
	$fillRect/AnimationPlayer.play("WipeDown_in")
	await $fillRect/AnimationPlayer.animation_finished
	get_tree().change_scene_to_file(target)
	$fillRect/AnimationPlayer.play("WipeDown_out")
