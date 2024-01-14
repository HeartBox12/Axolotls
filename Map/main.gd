extends Node2D
var day = 1
var playerPos #Player position in tilemap coords.
var lookPos

signal daytime #Connects to plants to tell them to ripen.

var allTargets = [$plant] #Things that the enemies could theoretically attack.

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
		$indicator.position = $Tiles.map_to_local(lookPos)

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
