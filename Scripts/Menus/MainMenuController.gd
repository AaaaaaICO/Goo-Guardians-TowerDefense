extends Control

@export_group("Tween/on_hover_Large")
@export var EndSizeLarge : Vector2
@export var DurLarge : float

@export_group("Tween/on_hover_Small")
@export var EndSizeSmall : Vector2
@export var DurSmall : float

func _ready():
	Global.Load()
	get_node("MC_settings/ScrollContainer/VBoxContainer/AUDIO/MarginContainer/MUSIC/HBoxContainer/HSlider").set_value(Global.Settings["User"]["MUSIC_Volume"])
	get_node("MC_settings/ScrollContainer/VBoxContainer/AUDIO/MarginContainer/MUSIC/HBoxContainer2/HSlider").set_value(Global.Settings["User"]["SFX_Volume"])
	var count = 1
	for level in Global.Settings["Save"]["Levels"]:
		if(level[1] == true):
			var WorldBox = load("res://Scenes/Menus/MainMenu_LevelBtn.tscn").instantiate()
			WorldBox.get_node("Button").set_text("Level : " + str(count))
			WorldBox.newScene = level[0]
			count+=1
			get_node("MC_levels/ScrollContainer/HFlowContainer").add_child(WorldBox)
			
	for x in Global.Settings["Save"]:
		for y in Global.Settings["Save"][x]:
			if(len(y) >= 4 and y[1] == false):
				await(get_tree().create_timer(.1).timeout)
				var achivementBox = load("res://Scenes/Menus/DisplayUnlockItem.tscn").instantiate()
				achivementBox.get_node("ColorRect/LBL_msg").set_text(y[3])
				get_node("MarginContainer/VBoxContainer/ScrollContainer/VBoxContainer").add_child(achivementBox)
func _on_btn_levels_mouse_entered():
	var tween = get_tree().create_tween()
	tween.tween_property(get_node("MarginContainer/VBoxContainer/Control/BTN_LEVELS"), "scale", EndSizeLarge, DurLarge).set_trans(Tween.TRANS_QUAD)
	tween.parallel().tween_property(get_node("MarginContainer/VBoxContainer/Control/BTN_LEVELS"), "modulate", Color.WHITE, DurLarge/2).set_trans(Tween.TRANS_QUAD)
func _on_btn_levels_mouse_exited():
	var tween = get_tree().create_tween()
	tween.tween_property(get_node("MarginContainer/VBoxContainer/Control/BTN_LEVELS"), "scale", Vector2(1,1), DurLarge).set_trans(Tween.TRANS_QUAD)
	tween.parallel().tween_property(get_node("MarginContainer/VBoxContainer/Control/BTN_LEVELS"), "modulate", Color("C0c0c0"), DurLarge/2).set_trans(Tween.TRANS_QUAD)


func _on_btn_settings_mouse_entered():
	var tween = get_tree().create_tween()
	tween.tween_property(get_node("MarginContainer/VBoxContainer/Control3/BTN_Settings"), "scale", EndSizeSmall, DurSmall).set_trans(Tween.TRANS_QUAD)
	tween.parallel().tween_property(get_node("MarginContainer/VBoxContainer/Control3/BTN_Settings"), "modulate", Color.WHITE, DurSmall/2).set_trans(Tween.TRANS_QUAD)
func _on_btn_settings_mouse_exited():
	var tween = get_tree().create_tween()
	tween.tween_property(get_node("MarginContainer/VBoxContainer/Control3/BTN_Settings"), "scale", Vector2(1,1), DurSmall).set_trans(Tween.TRANS_QUAD)
	tween.parallel().tween_property(get_node("MarginContainer/VBoxContainer/Control3/BTN_Settings"), "modulate", Color("C0c0c0"), DurSmall/2).set_trans(Tween.TRANS_QUAD)



func _on_btn_exit_mouse_entered():
	var tween = get_tree().create_tween()
	tween.tween_property(get_node("MarginContainer/VBoxContainer/Control2/BTN_Exit"), "scale", EndSizeSmall, DurSmall).set_trans(Tween.TRANS_QUAD)
	tween.parallel().tween_property(get_node("MarginContainer/VBoxContainer/Control2/BTN_Exit"), "modulate", Color.WHITE, DurSmall/2).set_trans(Tween.TRANS_QUAD)
func _on_btn_exit_mouse_exited():
	var tween = get_tree().create_tween()
	tween.tween_property(get_node("MarginContainer/VBoxContainer/Control2/BTN_Exit"), "scale", Vector2(1,1), DurSmall).set_trans(Tween.TRANS_QUAD)
	tween.parallel().tween_property(get_node("MarginContainer/VBoxContainer/Control2/BTN_Exit"), "modulate", Color("C0c0c0"), DurSmall/2).set_trans(Tween.TRANS_QUAD)

func _on_btn_exit_pressed():
	get_tree().quit()

func _on_btn_settings_pressed():
	get_node("MarginContainer").visible = false
	get_node("MC_settings").visible = true

func _on_btn_levels_pressed():
	get_node("MarginContainer").visible = false
	get_node("MC_levels").visible = true

func _on_btn_save_pressed():
	get_node("MarginContainer").visible = true
	get_node("MC_settings").visible = false
	Global.Save()


func _on_h_slider_value_changed(value):
	Global.Settings["User"]["MUSIC_Volume"] = value


func _on_sfxh_slider_value_changed(value):
	Global.Settings["User"]["SFX_Volume"] = value
