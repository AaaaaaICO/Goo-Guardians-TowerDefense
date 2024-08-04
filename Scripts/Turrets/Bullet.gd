extends CharacterBody2D

var Damage : int
var BulletSpeed : float
var BulletSize : float
var BulletSprite : Texture2D
var Index = 0
var PopCount = 0

@onready var __NULL__ = get_node("__NULL__")

# Called when the node enters the scene tree for the first time.
func _ready():
	__NULL__.set_scale(Vector2(BulletSize, BulletSize))
	__NULL__.get_node("__SPRITE__").set_texture(BulletSprite)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	position += transform.x * ((BulletSpeed * delta) * 150)
	move_and_slide()
	
func Destroy():
	Global.Settings["Save"]["Unlocked-Turrets"][Index][2] += PopCount
	PopCount = 0
	queue_free()
func __OnScreenNotifier__screen_exited():
	Destroy()
