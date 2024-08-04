extends Node

#{"Enemy": "","NumberToSpawn": 0,"Delay": 0.0,"EndDelay": 0.0}
@export_group("Round")
@export var Rounds =[
	[
		{"EnemyPath": "","NumberToSpawn": 0,"Delay": 0.0,"EndDelay": 0.0},
		{"EnemyPath": "","NumberToSpawn": 0,"Delay": 0.0,"EndDelay": 0.0},
		{"EnemyPath": "","NumberToSpawn": 0,"Delay": 0.0,"EndDelay": 0.0},
	],
	[
		{"EnemyPath": "","NumberToSpawn": 0,"Delay": 0.0,"EndDelay": 0.0},
		{"EnemyPath": "","NumberToSpawn": 0,"Delay": 0.0,"EndDelay": 0.0},
		{"EnemyPath": "","NumberToSpawn": 0,"Delay": 0.0,"EndDelay": 0.0},
	],
]
@export_group("Wave")

@export var WaveStyle = false
@export var WaveSettings = [
	{"EnemyPath": "", "StartOnRound": 0, "Cluster": 0, "Density": 0.0,"SpawnRate": 0, "FinalRound": 0},
	{"EnemyPath": "", "StartOnRound": 0, "Cluster": 0, "Density": 0.0, "SpawnRate": 0, "FinalRound": 0},
	{"EnemyPath": "", "StartOnRound": 0, "Cluster": 0, "Density": 0.0, "SpawnRate": 0, "FinalRound": 0},
]
@export var DecreaseSpawnRate = 1
var CurrentWave = 0
@export_group("Wave-Slots")
@export var Slots = 5
@export var SlotsIncreaseBy = 2
@export var SlotsIncreaseEvery = 3

var thread: Thread
var RoundWave = []
var RoundCluster = []
var RoundDensity = []
func _ready():
	if(!WaveStyle):
		var round = 0
		for Round in Rounds:
			round += 1
			get_parent().get_parent().get_parent().NewRound(round)
			for Group in Round:
				SpawnEnemyGroup(Group)
				var TimeAdd = 0.0
				for x in range(Group["NumberToSpawn"]):
					TimeAdd += Group["Delay"]
				await(get_tree().create_timer(Group["EndDelay"] + TimeAdd).timeout)
	else:
		thread = Thread.new()
		thread.start(Wave.bind())
func _process(delta):
	pass
func Wave():
	while true:
		var GenerateRound = func (Wave):
			RoundWave = []
			RoundCluster = []
			var SpawnChance = []
			var SpawnChanceCluster = []
			var SpawnChanceDensity = []
			for x in WaveSettings:
				if(Wave >= x["StartOnRound"]):
					var Spawnrate = x["SpawnRate"]
					if(x["StartOnRound"] == Wave):
						SpawnChance.append(x["EnemyPath"])
						SpawnChanceCluster.append(randi_range(int(x["Cluster"]*0.75),int(x["Cluster"]*1.25)))
						SpawnChanceDensity.append(randi_range(float(x["Density"]- 0.2),float(x["Density"]+0.2)))
					if(x["FinalRound"] - Wave <= 10):
						for i in range((x["FinalRound"]-Wave)-10):
							Spawnrate += -DecreaseSpawnRate
					if(x["FinalRound"] < Wave):
						Spawnrate = 0
					for i in range(Spawnrate):
						SpawnChance.append(x["EnemyPath"])
						SpawnChanceCluster.append(randi_range(int(x["Cluster"]*0.75),int(x["Cluster"]*1.25)))
						SpawnChanceDensity.append(randi_range(float(x["Density"]- 0.2),float(x["Density"]+0.2)))
			for x in Slots:
				if(SpawnChance):
					var rnd = randi_range(0, (len(SpawnChance)-1))
					RoundWave.append(SpawnChance[rnd])
					RoundCluster.append(SpawnChanceCluster[rnd])
					RoundDensity.append(SpawnChanceDensity[rnd])
		CurrentWave += 1
		GenerateRound.call(CurrentWave)
		for x in range(len(RoundWave)):
			for y in range(len(RoundCluster)):
				var LoadedEnemy = load(str(RoundWave[x-1])).instantiate()
				get_parent().get_parent().add_child(LoadedEnemy)
				LoadedEnemy.set_position(get_parent().get_parent().get_node("__ENEMYSPAWN__").get_position())
				await(get_tree().create_timer(RoundDensity[x-1]*0.10).timeout)
			await(get_tree().create_timer(randi_range(.8,1.3)).timeout)
		await(get_tree().create_timer(4).timeout)
		if(has_decimal(CurrentWave/SlotsIncreaseEvery)):
			Slots += SlotsIncreaseBy
		get_parent().get_parent().get_parent().NewRound(CurrentWave)

func has_decimal(f:float) -> bool:
	return abs(f - int(f)) > 0
	
	
func SpawnEnemyGroup(Dict):
	for Enemy in range(Dict["NumberToSpawn"]):
		var LoadedEnemy = load(str(Dict["EnemyPath"])).instantiate()
		get_parent().get_parent().add_child(LoadedEnemy)
		LoadedEnemy.set_position(get_parent().get_parent().get_node("__ENEMYSPAWN__").get_position())
		await(get_tree().create_timer(Dict["Delay"]).timeout)
