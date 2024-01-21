extends Node2D

signal coordValid
signal setup

@export var plant:PackedScene
@export var turret:PackedScene
@export var initSeeds:int
@export var initLimes:int

@export var plantSpot:Vector2i
@export var turrSpot:Vector2i

var playerPos #Player position in tilemap coords.
var selPos #The tile currently selected by the player

var phase = 0 #The step that the player is on. Checked for a few things
#0 [start] - Player is prompted to place a lime on plantSpot
#1 [plant is planted] - Day passes, plant ripens. Player prompted to harvest.
#2 [Plant harvested] - Player prompted to plant on turrSpot
#3 [Turret built] - Enemy spawns. Plant spawns. Player told about cost increases
#4 [Enemy killed] - Shutter w/ text falls. Booted to main menu.

# Called when the node enters the scene tree for the first time.
func _ready():
	setup.emit()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_player_coord_select(coords):
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
		
