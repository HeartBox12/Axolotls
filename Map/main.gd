extends Node2D

signal daytime #Connects to plants to tell them to ripen.

@export var plant:PackedScene
@export var turret:PackedScene

var day = 1
var playerPos #Player position in tilemap coords.
var lookPos
var selPos

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _process(delta):
	#Get tilemap coords of tile the player is standing on
	playerPos = $Tiles.local_to_map($Player.position)
	lookPos = playerPos

	if Input.is_action_pressed("move_left"):
		lookPos.x -= 1
	if Input.is_action_pressed("move_down"):
		lookPos.y += 1
	if Input.is_action_pressed("move_right"):
		lookPos.x += 1
	if Input.is_action_pressed("move_up"):
		lookPos.y -= 1
	
	if playerPos != lookPos:
		selPos = lookPos
		$indicator.position = $Tiles.map_to_local(selPos)

func adjust_day():
	if day > 1:
		$Control/DayCount.text = "[center]The stars will alime in [color=#00FF00]%s days[/color][/center]" %[day]
		$Control/DayCount/TextShadow.text = "[center][color=#000000]The stars will alime in[/color][color=#003300] %s days[/color][/center]"%[day]
	else:
		$Control/DayCount.text = "[center]The stars will alime in [color=#00FF00]1 day[/color][/center]"
		$Control/DayCount/TextShadow.text = "[center][color=#000000]The stars will alime in[/color][color=#003300] 1 day[/color][/center]"

func start_day(): #Start the day timer, change player to the idle state, etc.
	Global.Daytime.emit()
	#$Player.position = some starting point to be decided (use a marker2D)

func start_night(): #Begin spawning enemies, etc.
	Global.Nighttime.emit()

func _unhandled_input(event):
	if event.is_action_pressed("interact_plant"):
		var data = $Tiles.get_cell_tile_data(0, selPos)
		
		match data.get_custom_data("OccuType"):
			0: #Nothing
				var instance = plant.instantiate()
				$Tiles.add_child(instance)
				print($Tiles.local_to_map(selPos))
				instance.position = $Tiles.map_to_local(selPos)
				if data:
					data.set_custom_data("Occupant", instance)
				
				#create plant
			1: #plant
				pass
				#if plant is ripe:
					#plant.harvest
				#else:
					#plant.regain
			2: #turret
				pass
				#nothing
	
	if event.is_action_pressed("interact_turret"):
		var data = $Tiles.get_cell_tile_data(1, selPos)
		pass
		#if [tile type] is empty:
			#create turret
