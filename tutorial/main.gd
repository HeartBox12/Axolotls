extends Node2D

signal coordValid
signal tutSetup
signal finished

signal setPlant
signal setTurret
signal setHarvest

@export var plant:PackedScene
@export var turret:PackedScene
@export var enemy:PackedScene
@export var initSeeds:int
@export var initLimes:int

@export var plantSpot:Vector2i
@export var turrSpot:Vector2i

var playerPos #Player position in tilemap coords.
var selPos #The tile currently selected by the player

var plantInstance
var turretInstance
var enemyInstance

 #The step that the player is on. Checked for a few things
var phase:int : set = _phaseAdvance
#0 [start] - Player is prompted to place a lime on plantSpot
#1 [plant is planted] - Plant info comes up. Player prompted to press space.
#2 [Space pressed] - Day passes, plant ripens. Player prompted to harvest.
#3 [Plant harvested] - Player prompted to build on turrSpot
#4 [Turret built] - Enemy spawns. Plant spawns. Player told about cost increases.
#5 [Space pressed] - Shutter w/ text falls. Booted to main menu.
func _load():
	tutSetup.emit() #Gets the player into the idle state
	Global.limes = initLimes
	Global.seeds = initSeeds
	$Control/counters/TurretCost.text = str(Global.turretPrices[Global.turrPriceInd])
	phase = 0 #It begins
	$Player.toggleMove()

func _phaseAdvance(new): #Called automatically when phase is rewritten.
	phase = new
	
	match phase:
		0: #tutorial entered
			$AnimationPlayer.play("phase0")
		1: #Plant planted
			$AnimationPlayer.play("phase1")
		2: #SPACE pressed
			$AnimationPlayer.play("phase2")
		3: #Plant harvested
			coordValid.emit(false)
			$AnimationPlayer.play("phase3")
		4:#turret placed
			coordValid.emit(false)
			spawnemy()
			$AnimationPlayer.play("phase4")
		5: #Enemy killed
			$AnimationPlayer.play("phase5")

func _on_player_coord_select(coords):
	selPos = coords
	if coords:
		$indicator.position = $tiles.map_to_local(coords)
	
	if phase <= 2 && coords == plantSpot:
#		$indicator.visible = true
#		$indicator.position = $tiles.map_to_local(plantSpot)
		coordValid.emit(true)
	elif phase == 3 && coords == turrSpot:
#		$indicator.visible = true
#		$indicator.position = $tiles.map_to_local(turrSpot)
		coordValid.emit(true)
	else:
#		$indicator.visible = false
		coordValid.emit(false)

func _on_player_reqPlant(coords):
	if phase == 0 && coords == plantSpot:
		setPlant.emit()
	if phase == 2 && coords == plantSpot:
		setHarvest.emit()

func _on_player_planted(_coords): #player transmits after completed planting
	if phase != 0:
		print("Error! Error! Sequence broken!")
	
	plantInstance = plant.instantiate()
	$tiles.add_child(plantInstance)
	plantInstance.position = $tiles.map_to_local(plantSpot)
	
	Global.seeds -= Global.plantCost
	$Control/counters/SeedCount.text = str(Global.seeds)
	
	plantInstance.destroyed.connect(_plant_down)
	
	phase = 1

func _on_player_harvested(_coords): #Player harvests a plant at coords
	Global.limes += plantInstance.profit
	plantInstance.remove()
	$Control/counters/LimeCount.text = str(Global.limes)
	phase = 3

func _start_day():
	Global.Daytime.emit()

func _plant_down():
	pass#FIXME: end the tutorial

func _on_player_reqTurret(coords):
	if phase == 3 && coords == turrSpot:
		setTurret.emit()

func _on_player_turreted(_coords):
	turretInstance = turret.instantiate()
	add_child(turretInstance)
	turretInstance.position = $tiles.map_to_local(turrSpot)
	
	Global.seeds -= 1
	$Control/counters/SeedCount.text = str(Global.limes)
	
	phase = 4

func spawnemy():
	
	enemyInstance = enemy.instantiate()
	enemyInstance.position = $enemSpawn.position
	add_child(enemyInstance)
	enemyInstance.death.connect(_on_enemy_down)
	#clear.connect(Callable(enemyInstance, "_on_clear"))
	
func _on_enemy_down(_instance):
	phase = 5

func _unhandled_input(event):
	if event.is_action_pressed("begin_day") && phase == 1: #Placeholder
		phase = 2

func _close():
	finished.emit()
