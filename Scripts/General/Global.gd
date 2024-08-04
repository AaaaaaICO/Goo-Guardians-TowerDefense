extends Node

var Library = {
	"SFX": {
		"enemy-hit": "res://Sounds/SFX/Smallpop.wav",
		"enemy-death": "res://Sounds/SFX/pop.wav"
	},
	"Levels": ["res://Scenes/Maps/Map 1.tscn","res://Scenes/Maps/Map 2.tscn"] 
	
}
var Settings = {
	"User": {
		"SFX_Volume": 1,
		"MUSIC_Volume": 1
	},
	"Save": {
		"Levels": [
		["res://Scenes/Maps/Map 1.tscn", true, 0, ],
		["res://Scenes/Maps/Map 2.tscn", false, 0, "Level 2: Unlocked by finishing round 15 in level 1"],
		],
		"Unlocked-Turrets": [
		["res://Scenes/Turrets/Turret.tscn", true, 0,],
		["res://Scenes/Turrets/Shotgun.tscn", true, 0],
		["res://Scenes/Turrets/Sniper.tscn", false,0, "Sniper Turret: Unlocked by finishing round 20 in level 1 or round 10 in level 2"],
		["res://Scenes/Turrets/Uzi.tscn", false,0, "Uzi Turret: Unlocked by getting 1000 kills with the Sniper Turret", 2, 1000]
		]
	}
} 
var Level = ""
var CurrentRound = 0
var CurrentUnlocks = [
]

func PlaySound(Sound, Volume ,Path):
	Path.set_stream(load(Sound))
	if(Settings["User"]["SFX_Volume"] != 0):
		print((Volume * Settings["User"]["SFX_Volume"])/50)
		Path.set_volume_db((Volume * Settings["User"]["SFX_Volume"])/50)
		Path.play(0)
	
func Unlock(x):
	if(x["isTurret"] == true):
		if(get("Settings")["Save"]["Unlocked-Turrets"][int(x["Index"])][1] != true):
			get("Settings")["Save"]["Unlocked-Turrets"][int(x["Index"])][1] = true
			CurrentUnlocks.append(str(x["Message"]))
	else:
			get("Settings")["Save"]["Levels"][int(x["Index"])][1] = true
			CurrentUnlocks.append(str(x["Message"]))
	
var saveLocation = "user://saves.cfg"
func Save():
	var config = ConfigFile.new()
	var configFile = config.load(saveLocation)
	config.set_value("Profile", "Data", Settings)
	config.save(saveLocation)
func Load():
	var config = ConfigFile.new()
	var configFile = config.load(saveLocation)
	if(config.get_value("Profile", "Data")):
		Settings = config.get_value("Profile", "Data")
	else:
		Save()
	return config.get_value("Profile", "Data")
