extends Node2D

signal daytime #Connects to plants to tell them to ripen.

@export var plant:PackedScene
@export var turret:PackedScene

@export var boundX:int = 27 #Number of columns + 2
@export var boundY:int = 14 #number of rows + 2

var day = 1
var playerPos #Player position in tilemap coords.
var lookPos
var selPos
var tiledNodes:Array = []
var isDay

# Called when the node enters the scene tree for the first time.
func _ready():
	#Declare array sizes
	for i in range(boundX):
		tiledNodes.append([])
		for j in range(boundY):
			tiledNodes[i].append(null)

func _process(delta):
	if isDay:
		$Control/dayTimer.value -= delta
	
	if $Control/dayTimer.value <= 0:
		$AnimationPlayer.play("startOfNight")
		isDay = false
	
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
		if $Tiles.get_cell_tile_data(0, lookPos).get_custom_data("valid"):
			selPos = lookPos
			$indicator.visible = true
			$indicator.position = $Tiles.map_to_local(selPos)
		else:
			$indicator.visible = false

func adjust_day():
	if day > 1:
		$Control/DayCount.text = "[center]The stars will alime in [color=#00FF00]%s days[/color][/center]" %[day]
		$Control/DayCount/TextShadow.text = "[center][color=#000000]The stars will alime in[/color][color=#003300] %s days[/color][/center]"%[day]
	else:
		$Control/DayCount.text = "[center]The stars will alime in [color=#00FF00]1 day[/color][/center]"
		$Control/DayCount/TextShadow.text = "[center][color=#000000]The stars will alime in[/color][color=#003300] 1 day[/color][/center]"

func start_day():
	$AnimationPlayer.play("startOfDay")
	Global.Daytime.emit()
	$Control/dayTimer.value = $Control/dayTimer.max_value
	isDay = true #for timer purposes
	
	#$Player.position = some starting point to be decided (use a marker2D)

func start_night(): #Begin spawning enemies, etc.
	Global.Nighttime.emit()

func _unhandled_input(event):
	if event.is_action_pressed("interact_plant"):
		var selected = tiledNodes[selPos.x][selPos.y]
		
		if selected == null:
			var instance = plant.instantiate()
			$Tiles.add_child(instance)
			instance.position = $Tiles.map_to_local(selPos)
			tiledNodes[selPos.x][selPos.y] = instance
			#if plant is ripe:
				#plant.harvest
			#else:
			#plant.regain
			
			#turret
				#nothing
	
	if event.is_action_pressed("interact_turret"):
		var selected = tiledNodes[selPos.x][selPos.y]
		if selected == null:
			var instance = turret.instantiate()
			$Tiles.add_child(instance)
			instance.position = $Tiles.map_to_local(selPos)
			tiledNodes[selPos.x][selPos.y] = instance
			
	if Input.is_action_just_pressed("test_button_to_make_something_happen"):
		$AnimationPlayer.play("endOfNight")
