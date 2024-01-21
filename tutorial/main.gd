extends Node2D

signal coordValid
signal tutSetup

signal setPlant
signal setTurret
signal setHarvest

@export var plant:PackedScene
@export var turret:PackedScene
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
var phase = 0 : set = _phaseAdvance
#0 [start] - Player is prompted to place a lime on plantSpot
#1 [plant is planted] - Day passes, plant ripens. Player prompted to harvest.
#2 [Plant harvested] - Player prompted to plant on turrSpot
#3 [Turret built] - Enemy spawns. Plant spawns. Player told about cost increases
#4 [Enemy killed] - Shutter w/ text falls. Booted to main menu.

func _ready():
	setup()

func setup():
	tutSetup.emit() #Gets the player into the idle state
	Global.limes = initLimes
	Global.seeds = initSeeds
	$Control/counters/TurretCost.text = str(Global.turretPrices[Global.turrPriceInd])
	phase = 0 #It begins

func _phaseAdvance(new): #Called automatically when phase is rewritten.
	phase = new
	
	match phase:
		0:
			pass
		1:
			pass
		2:
			pass
		3:
			pass
		4:
			pass

func _on_player_coord_select(coords):
	selPos = coords
	
	if phase == 0 && coords == plantSpot:
		$indicator.visible = true
		$indicator.position = $tiles.map_to_local(plantSpot)
		coordValid.emit(true)
	elif phase == 2 && coords == turrSpot:
		$indicator.visible = true
		$indicator.position = $tiles.map_to_local(turrSpot)
		coordValid.emit(true)
	else:
		$indicator.visible = false
		coordValid.emit(false)

func _on_player_planted(coords): #player transmits after completed planting
	if phase != 0:
		print("Error! Error! Sequence broken!")
	
	plantInstance = plant.instantiate()
	$tiles.add_child(plantInstance)
	plantInstance.position = $tiles.map_to_local(plantSpot)
	
	Global.seeds -= Global.plantCost
	$Control/counters/SeedCount.text = str(Global.seeds)
	
	plantInstance.destroyed.connect(_plant_down)
	
	phase = 2

func _plant_down():
	pass#FIXME: end the tutorial

func _on_player_reqPlant(coords):
	if phase == 0 && coords == plantSpot:
		setPlant.emit()

func _on_player_reqTurret(coords):
	if phase == 2 && coords == turrSpot:
		setPlant.emit()

func _on_player_turreted():
	turretInstance = turret.instantiate()
	$Tiles.add_child(turretInstance)
	turretInstance.position = $Tiles.map_to_local(turrSpot)
	
	Global.seeds -= 1
	$Control/counters/SeedCount.text = str(Global.limes)
