extends Node2D

#@export var Turrets : Array
@export var Unlocks = [
	{
		"isTurret": true,
		"Index": 0,
		"Message": "",
		"RequiredRound": 0
	}
]
@export var SpreadIcon : String
@export var RadiusIcon : String
var ToUpgrade = false
var Radius = true
var AwaitingUpgrade = "" # match "RADIUS" "FIRERATE" "DMG"


var HOLDING = false
var HOLDINGTURRET = false
var CanStopHolding = true
var CurRound = 0

var NumOfEnemys = 0
var childrenInPath = []
var LOADEDTurret
var Health = 100
@export var MaxHealth = 100
var MoneyOwned = 100
var Debt = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	Health = MaxHealth
	get_node("__UI__/Control/MarginContainer/VBoxContainer2/ColorRect/HBoxContainer/MarginContainer/PB_Healthbar").set_max(MaxHealth)
	get_node("__UI__/Control/MarginContainer/VBoxContainer2/ColorRect/HBoxContainer/MarginContainer/PB_Healthbar").set_value(MaxHealth)
	for Turret in Global.Settings["Save"]["Unlocked-Turrets"]:
		if(Turret[1] == true):
			var TurretItemBox = load("res://Scenes/Turrets/Turret_Item_Box.tscn").instantiate()
			TurretItemBox.TurretScene = Turret[0]

			get_node("__UI__/Control/MarginContainer/VBoxContainer2/HFC_TurretItems").add_child(TurretItemBox)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if(Input.is_action_just_pressed("ui_cancel")):
		$__UI__/ConfirmationDialog.visible = true
	
	if(ToUpgrade and get_node("__UI__/Control/MarginContainer/VBoxContainer2/MarginContainer").visible == false):
		if(Radius):
			get_node("__UI__/Control/MarginContainer/VBoxContainer2/MarginContainer/Panel/VBoxContainer/Null/MarginContainer/HBoxContainer/PanelContainer/BTN_Radius").set_text("Radius")
			get_node("__UI__/Control/MarginContainer/VBoxContainer2/MarginContainer/Panel/VBoxContainer/Null/MarginContainer/HBoxContainer/PanelContainer/BTN_Radius").set_button_icon(load(RadiusIcon))
		else:
			get_node("__UI__/Control/MarginContainer/VBoxContainer2/MarginContainer/Panel/VBoxContainer/Null/MarginContainer/HBoxContainer/PanelContainer/BTN_Radius").set_text("Spread")
			get_node("__UI__/Control/MarginContainer/VBoxContainer2/MarginContainer/Panel/VBoxContainer/Null/MarginContainer/HBoxContainer/PanelContainer/BTN_Radius").set_button_icon(load(SpreadIcon))
		get_node("__ANIM__").play("RESET")
		get_node("__ANIM__").play("to_upgrade_open")
		get_node("__UI__/Control/MarginContainer/VBoxContainer2/MarginContainer").visible = true
	if(ToUpgrade):
		if(Input.is_action_just_pressed("Slot_1")):
			AwaitingUpgrade = "RADIUS"
			
		if(Input.is_action_just_pressed("Slot_2")):
			AwaitingUpgrade = "FIRERATE"

		if(Input.is_action_just_pressed("Slot_3")):
			AwaitingUpgrade = "DMG"

	if(!ToUpgrade and get_node("__UI__/Control/MarginContainer/VBoxContainer2/MarginContainer").visible == true):
		get_node("__ANIM__").play("to_upgrade_close")
	get_node("__UI__/Control/MarginContainer/VBoxContainer2/ColorRect/HBoxContainer/LBL_MONEY").set_text("$"+str(MoneyOwned))
	if (Input.is_action_just_pressed("Place_Turret")):
		if(HOLDING):
			if(CanStopHolding):
				PlaceTuret()
	if (Input.is_action_just_pressed("Cancel_Turret")):
		if(HOLDINGTURRET):
			if(HOLDING):
				if(CanStopHolding):
					PlaceTuret()
					await(get_tree().create_timer(.15).timeout)
					LOADEDTurret.queue_free()
					GiveMoney(-Debt)
					await(get_tree().create_timer(.3).timeout)
					ToUpgrade = false
	NumOfEnemys = 0
	childrenInPath.clear()
	for child in $__PATH__.get_children():
		if(child.name != "__AREA__" and child.name != "__ENEMYSPAWN__"):
			NumOfEnemys = NumOfEnemys + 1
			childrenInPath.append(child)
	
func NewRound(Round):
	CurRound = Round
	Global.CurrentRound = CurRound
	get_node("__UI__/Control/MarginContainer/VBoxContainer2/ColorRect/HBoxContainer/LBL_ROUND").set_text("ROUND: " + str(Round))
	
	for x in Unlocks:
		if x["RequiredRound"] == Round:
			Global.Unlock(x)

func GiveMoney(Amount):
	MoneyOwned += Amount
	if(Amount < 0):
		Debt = Amount
	else:
		Debt = 0
func TakeDMG(Amount):
	Health -= Amount
	print(Health)
	get_node("__UI__/Control/MarginContainer/VBoxContainer2/ColorRect/HBoxContainer/MarginContainer/PB_Healthbar").set_value(Health)
	if(Health <= 0):
		DeathState()
func DeathState():
	SceneTransition.changeScene("res://Scenes/Menus/DeathScreen.tscn")
func PlaceTuret():
	var pos = LOADEDTurret.get_position()
	await(get_tree().create_timer(.05).timeout)
	if(!LOADEDTurret.get_node("__AREA__").has_overlapping_areas()):
		LOADEDTurret.set_position(pos)
		HOLDING = false
		HOLDINGTURRET = false
func HoldTurret(Turret):
	if(HOLDINGTURRET == false):
		HOLDINGTURRET = true
		LOADEDTurret = load(Turret).instantiate()
		GiveMoney(-LOADEDTurret.StartingCost)
		get_node("__TurretContainer__").add_child(LOADEDTurret)
		HOLDING = true
		while HOLDING == true:
			CanStopHolding = LOADEDTurret.CanBePlaced
			var mpos = get_viewport().get_mouse_position()
			mpos[0] = mpos[0] - 1920/2
			mpos[1] = mpos[1] - 1080/2
			LOADEDTurret.set_position(mpos)
			await(get_tree().create_timer(.01).timeout)
		if(!HOLDING):
			LOADEDTurret.Placed = true		
func _on_place_pressed():
	HoldTurret("res://Scenes/Turrets/Turret.tscn")


func _on___anim___animation_finished(anim_name):
	if(anim_name == "to_upgrade_close"):
		get_node("__UI__/Control/MarginContainer/VBoxContainer2/MarginContainer").visible = false


func _on_margin_container_visibility_changed():
	get_node("__ANIM__").play("RESET")


func _on_confirmation_dialog_confirmed():
	TakeDMG(500)
	$__UI__/ConfirmationDialog.visible = false
	

func _on_confirmation_dialog_canceled():
	$__UI__/ConfirmationDialog.visible = false
