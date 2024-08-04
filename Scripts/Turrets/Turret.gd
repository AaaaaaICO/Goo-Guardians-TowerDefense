extends Node2D
@export_group("Settings")
@export var DefRangeScale = 0.15
@export var Index : int
@export_group("Stats")
@export var TurretName : String
@export var FireRate : float
@export var FireRateIncrease : float
@export var NumOfProj : int
@export var Damage : int
@export var DamageIncrease : int
@export var Distance : float
@export var DistanceIncrease : float

@export var BulletSpread : float
@export var BulletSpreadIncrease : float


@export var UsingRadius : bool

@export_group("Cost-Upgrades")
@export var StartingCost : int
@export var CostMultiplier : float
@export var MaxUpgrades : int
@export  var UpgradeMulti = 1.1
var CurrentUpgrades : int
var Cost : int
@export_group("Bullet/Settings")
@export var BulletSize : float
@export var BulletSpeed : float
@export_group("Bullet/Objects")
@export var BulletSprite : Texture2D
@export var Projectile : PackedScene


@onready var Disabled = get_node("__Disabled__")
var Hovering = false
var WasHovering = false
var Upgrading = false

var AddSprite = false
var Placed = false
var CanBePlaced = true

var Closest = ""
var ClosestDist = ""
var HighestProg = ""

var thread: Thread
# Called when the node enters the scene tree for the first time.
func _ready():
	if(BulletSprite):
		AddSprite = true
	thread = Thread.new()
	thread.start(Target.bind())
	thread = Thread.new()
	thread.start(Shoot.bind())
	Cost = (StartingCost/2) * CostMultiplier
func Target():
	while true:
		if(Placed):
			await(get_tree().create_timer(.01).timeout)
			var Master = get_parent().get_parent().get_parent().get_node("Master")
			Closest = ""
			ClosestDist = ""
			for child in Master.childrenInPath:
				if child != null:
					var dist = position.distance_to(child.position)
					var prog = child.get_progress()
					if(float(dist) <= float(Distance * 36)):
						if !Closest:
							Closest = child
							ClosestDist = dist
							HighestProg = prog
						else:
							if HighestProg <= prog:
								ClosestDist = dist
								HighestProg = prog
								Closest = child
func Shoot():
	while true:
		if(Placed):
			if(Closest):
				if(float(ClosestDist) <= float(float(Distance) * 36)):
					for x in NumOfProj:
						var bullet = Projectile.instantiate()
						bullet.Damage = Damage
						bullet.BulletSize = BulletSize
						bullet.BulletSprite = BulletSprite
						bullet.BulletSpeed = BulletSpeed
						bullet.position = to_global(get_node("__MARKER__").get_position())
						bullet.Index = Index
						get_parent().add_child(bullet)
						bullet.look_at(Closest.position)
						bullet.set_rotation_degrees(bullet.get_rotation_degrees() + randi_range(-BulletSpread, BulletSpread))
					await(get_tree().create_timer(FireRate).timeout)
				else:
					await(get_tree().create_timer(.01).timeout)
			else:
				await(get_tree().create_timer(.01).timeout)

func GetCost(LVL):
	var Cost = StartingCost
	for x in range(LVL):
		Cost = Cost * CostMultiplier
	return Cost

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(Hovering):
		if(CurrentUpgrades < MaxUpgrades):
			get_parent().get_parent().ToUpgrade = true
			get_parent().get_parent().Radius = UsingRadius
			get_parent().get_parent().get_node("__UI__/Control/MarginContainer/VBoxContainer2/MarginContainer/Panel/VBoxContainer/Control/Price").set_text("$" + str(Cost))
			if(get_parent().get_parent().AwaitingUpgrade and get_parent().get_parent().MoneyOwned >= Cost):
				get_parent().get_parent().get_node("__ANIM__").play("buy_upgrade")
				get_node("__ANIM__").play("on_upgrade")
				CurrentUpgrades += 1
			else:
				get_parent().get_parent().AwaitingUpgrade = ""
			match get_parent().get_parent().AwaitingUpgrade:
				"RADIUS":
					if get_parent().get_parent().MoneyOwned >= Cost:
						get_parent().get_parent().GiveMoney(-Cost)
						Cost *= CostMultiplier
						if(UsingRadius):
							var multi = 0
							for x in range(0, CurrentUpgrades):
								if(multi):
									multi *= UpgradeMulti
								else:
									multi = UpgradeMulti
							Distance = Distance + (DistanceIncrease * multi)
						else:
							var multi = 0
							for x in range(0, CurrentUpgrades):
								if(multi):
									multi *= UpgradeMulti
								else:
									multi = UpgradeMulti
							BulletSpread = BulletSpread - (BulletSpreadIncrease * multi)
						get_parent().get_parent().AwaitingUpgrade = ""
					else:
						pass
				"FIRERATE":
					if get_parent().get_parent().MoneyOwned >= Cost:
						get_parent().get_parent().GiveMoney(-Cost)
						Cost *= CostMultiplier
						var multi = 0
						for x in range(0, CurrentUpgrades):
							if(multi):
								multi *= UpgradeMulti
							else:
								multi = UpgradeMulti
						FireRate = FireRate + (FireRateIncrease * multi)
						get_parent().get_parent().AwaitingUpgrade = ""
					else:
						pass
				"DMG":
					if get_parent().get_parent().MoneyOwned >= Cost:
						get_parent().get_parent().GiveMoney(-Cost)
						Cost *= CostMultiplier
						var multi = 0
						for x in range(0, CurrentUpgrades):
							if(multi):
								multi *= UpgradeMulti
							else:
								multi = UpgradeMulti
						Damage = Damage + (DamageIncrease * multi)
						get_parent().get_parent().AwaitingUpgrade = ""
					else:
						pass
		else:
			get_parent().get_parent().ToUpgrade = false
			WasHovering = false
	if(!Hovering and WasHovering):
		get_parent().get_parent().ToUpgrade = false
		WasHovering = false
	if(get_node("__AREA__").has_overlapping_areas()):
		var OverlappingAreas = get_node("__AREA__").get_overlapping_areas()
		for Area in OverlappingAreas:
			if(!Area.is_in_group("FRIENDLY_PROJECTILE")):
				CanBePlaced = false
				Disabled.visible = true
	else:
		CanBePlaced = true
		Disabled.visible = false
	if(Placed):
		if(Closest):
			if(is_instance_valid(Closest)):
				look_at(Closest.position)
				set_rotation_degrees(get_rotation_degrees() + 90)
				get_node("__NULL__/__BASE__").set_rotation_degrees(-get_rotation_degrees())
			else:
				Closest = ""
				ClosestDist = ""
	var ShootingRange = DefRangeScale * Distance
	get_node("__SCALABLE__/__RANGE__").set_scale(Vector2(ShootingRange, ShootingRange))


func _on___area___mouse_entered():
	Hovering = true
	WasHovering = true
	get_node("__ANIM__").play("on_hover")
	get_node("__SCALABLE__/__RANGE__").visible = true


func _on___area___mouse_exited():
	Hovering = false
	get_node("__ANIM__").play("on_hover_release")



func _on___anim___animation_finished(anim_name):
	if(anim_name == "on_hover_release" and !Hovering):
		get_node("__SCALABLE__/__RANGE__").visible = false
