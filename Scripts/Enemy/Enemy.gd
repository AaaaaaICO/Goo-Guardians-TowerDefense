extends PathFollow2D


@export var Speed : float
@export var MaxHealth : int
@export var MinMoneyDropped : int
@export var MaxMoneyDropped : int
@export var StatIncreasePerLevel = {
	"Speed" : 0.0,
	"MaxHealth" : 0.0,
}
@export_group("Particles")
@export var Deathparticles : PackedScene
@export var Hitparticles : PackedScene


var Order : int
var CurHealth = -1

var round = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	round = get_parent().get_parent().CurRound
	MaxHealth += get_parent().get_parent().CurRound * StatIncreasePerLevel["MaxHealth"]
	Speed +=  get_parent().get_parent().CurRound * StatIncreasePerLevel["Speed"]
	get_node("__HEALTHBAR__").set_max(MaxHealth)
	CurHealth = MaxHealth

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(MaxHealth == CurHealth): get_node("__HEALTHBAR__").visible = false
	else: get_node("__HEALTHBAR__").visible = true
	set_progress(float(get_progress()) + (Speed * delta) * 15)
	get_node("__HEALTHBAR__").set_value(CurHealth)
	if(get_progress_ratio() == 1):
		get_parent().get_parent().TakeDMG(1)
		queue_free()
	
func TakeDMG(DMG):
	CurHealth = CurHealth - DMG
	if(CurHealth <= 0):
		Destroy()
		return true
	else:
		Global.PlaySound(Global.Library["SFX"]["enemy-hit"] ,.75,get_parent().get_parent().get_node("__AudioStreamPlayer__"))
		var Particles = Hitparticles.instantiate()
		Particles.set_emitting(true)
		Particles.set_position(get_position())
		get_parent().get_parent().add_child(Particles)
		var anim = get_node("__ANIM__")
		anim.set_current_animation("on_hit")
		return false
func Destroy():
	Global.PlaySound(Global.Library["SFX"]["enemy-death"] ,10,get_parent().get_parent().get_node("__AudioStreamPlayer__"))
	var Particles = Deathparticles.instantiate()
	Particles.set_emitting(true)
	Particles.set_position(get_position())
	get_parent().get_parent().add_child(Particles)
	get_parent().get_parent().GiveMoney(randi_range(MinMoneyDropped, MaxMoneyDropped))
	queue_free()

func _on___area___area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	if(area.shape_owner_get_owner(area.shape_find_owner(area_shape_index)).is_in_group("FRIENDLY_PROJECTILE")):
		var take = TakeDMG(area.shape_owner_get_owner(area.shape_find_owner(area_shape_index)).get_parent().get_parent().get_parent().Damage)
		if take:
			area.shape_owner_get_owner(area.shape_find_owner(area_shape_index)).get_parent().get_parent().get_parent().PopCount+=1
		area.shape_owner_get_owner(area.shape_find_owner(area_shape_index)).get_parent().get_parent().get_parent().Destroy()
