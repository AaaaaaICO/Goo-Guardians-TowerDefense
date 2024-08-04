extends Control
@export var TimeBetweenNoti : float
@export_group("Tween/Large_Buttons")
@export var EndSize : Vector2
@export var Dur: float
func CheckTurretKillUnlocks():
	var index = 0
	for x in Global.Settings["Save"]["Unlocked-Turrets"]:
		if len(x) == 6:
			if(Global.Settings["Save"]["Unlocked-Turrets"][x[4]][2] >= x[5]):
				var temp = {
						"isTurret": true,
						"Index": index,
						"Message": x[3],
						"RequiredRound": -1
					}
				Global.Unlock(temp)
		index+=1
func _ready():
	
	CheckTurretKillUnlocks()
	
	$MarginContainer/VBoxContainer/VBoxContainer/LBL_Round.set_text("Round - " + str(Global.CurrentRound))
	for unlock in Global.CurrentUnlocks:
		await(get_tree().create_timer(TimeBetweenNoti).timeout)
		var noti = load("res://Scenes/Menus/UnlockNoti.tscn").instantiate()
		noti.msg = unlock
		get_node("MarginContainer/VBoxContainer/VBoxContainer/MarginContainer2/PanelContainer/ScrollContainer/VBoxContainer").add_child(noti)
	for x in Global.Settings["Save"]["Levels"]:
		if(str(x[0]) == str(Global.Level)):
			get_node("MarginContainer/VBoxContainer/VBoxContainer/LBL_Highscore").set_text("High Score - " + str(x[2]))
			if(Global.CurrentRound >= x[2]):
				x[2] = Global.CurrentRound
				get_node("MarginContainer/VBoxContainer/VBoxContainer/LBL_Highscore").set_text("NEW High Score - " + str(x[2]))
	Global.Save()
func _on_btn_home_mouse_entered():
	var tween = get_tree().create_tween()
	tween.tween_property(get_node("MarginContainer/VBoxContainer/VBoxContainer/MarginContainer/HBoxContainer/Control/BTN_Home"), "scale", EndSize, Dur).set_trans(Tween.TRANS_QUAD)
	tween.parallel().tween_property(get_node("MarginContainer/VBoxContainer/VBoxContainer/MarginContainer/HBoxContainer/Control/BTN_Home"), "modulate", Color.WHITE, Dur/2).set_trans(Tween.TRANS_QUAD)


func _on_btn_home_mouse_exited():
	var tween = get_tree().create_tween()
	tween.tween_property(get_node("MarginContainer/VBoxContainer/VBoxContainer/MarginContainer/HBoxContainer/Control/BTN_Home"), "scale", Vector2(1,1), Dur).set_trans(Tween.TRANS_QUAD)
	tween.parallel().tween_property(get_node("MarginContainer/VBoxContainer/VBoxContainer/MarginContainer/HBoxContainer/Control/BTN_Home"), "modulate", Color("C0c0c0"), Dur/2).set_trans(Tween.TRANS_QUAD)


func _on_btn_retry_mouse_entered():
	var tween = get_tree().create_tween()
	tween.tween_property(get_node("MarginContainer/VBoxContainer/VBoxContainer/MarginContainer/HBoxContainer/Control2/BTN_Retry"), "scale", EndSize, Dur).set_trans(Tween.TRANS_QUAD)
	tween.parallel().tween_property(get_node("MarginContainer/VBoxContainer/VBoxContainer/MarginContainer/HBoxContainer/Control2/BTN_Retry"), "modulate", Color.WHITE, Dur/2).set_trans(Tween.TRANS_QUAD)


func _on_btn_retry_mouse_exited():
	var tween = get_tree().create_tween()
	tween.tween_property(get_node("MarginContainer/VBoxContainer/VBoxContainer/MarginContainer/HBoxContainer/Control2/BTN_Retry"), "scale", Vector2(1,1), Dur).set_trans(Tween.TRANS_QUAD)
	tween.parallel().tween_property(get_node("MarginContainer/VBoxContainer/VBoxContainer/MarginContainer/HBoxContainer/Control2/BTN_Retry"), "modulate", Color("C0c0c0"), Dur/2).set_trans(Tween.TRANS_QUAD)


func _on_btn_home_pressed():
	SceneTransition.changeScene("res://Scenes/Menus/MainMenu.tscn")


func _on_btn_retry_pressed():
	SceneTransition.changeScene(Global.Level)
