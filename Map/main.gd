extends Node2D
var day = 2
var playerPos #Player position in tilemap coords.

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _process(delta):
	#Get tilemap coords of tile the player is standing on
	playerPos = $Tiles.local_to_map($Player.position)
	$indicator.position = $Tiles.map_to_local(playerPos)
	
	if $Player.input != Vector2(0, 0):
		if Input.is_action_pressed("move_left"):
			$indicator.position.x -= 1
		if Input.is_action_pressed("move_down"):
			$indicator.position.y += 1
		if Input.is_action_pressed("move_right"):
			$indicator.position.x += 1
		if Input.is_action_pressed("move_up"):
			$indicator.position.y -= 1

func adjust_day():
	$DayCount.text = "[center]The stars will alime in [color=#00FF00]%s days[/color][/center]" %[day]
	$DayCount/TextShadow.text = "[center][color=#000000]The stars will alime in[/color][color=#003300] %s days[/color][/center]"%[day]

func start_day(): #Start the day timer, change player to the idle state, etc.
	pass

func start_night(): #Begin spawning enemies, etc.
	pass
