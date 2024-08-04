extends Control

var TurretScene : String

@onready var TurretObject = load(TurretScene).instantiate()
# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("Panel/MarginContainer/VBoxContainer/LBL_Name").set_text(TurretObject.TurretName)
	get_node("Panel/MarginContainer/VBoxContainer/HBoxContainer/LBL_Price").set_text("$"+str(TurretObject.StartingCost))
	get_node("Panel/MarginContainer/VBoxContainer/HBoxContainer/CenterContainer/Sprite_Turret").set_texture(load("res://Sprites/Turrets/" + TurretObject.TurretName + "/" + TurretObject.TurretName + "_COMP.png"))


func _on_btn_buy_pressed():
	if(get_tree().get_root().get_node("Master").MoneyOwned >= TurretObject.StartingCost):
		get_tree().get_root().get_node("Master").HoldTurret(TurretScene)
