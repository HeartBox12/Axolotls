extends Node2D

signal daytime #Connects to plants to tell them to ripen.
signal clear #Connects to enemies so the script can wipe them out

@export var plant:PackedScene
@export var turret:PackedScene

@export var boundX:int = 29 #Number of columns + 4. Declare array sizes.
@export var boundY:int = 16 #number of rows + 4

@export var initSeeds:int
@export var initLimes:int
@export var lastDay:int #var day must equal this for the player to win
@export var dayLength:int

var day = 0 #Counts up to 0 when the game starts. Compared against lastDay for victory.
var playerPos #Player position in tilemap coords.
var selPos #The tile currently selected by the player
var tiledNodes:Array = [] #2d array for tracking which structures are where
var isDay:bool = false #for timer purposes
var livingEnems = 6 #Living enemies. When it reaches 0, start day. FIXME: set 0.
var enemArray = []

var puns = ["FUCK YOU BDOSFISDJFSODKFSDFSDFSDFSDFSDFSDFSDFSDFSDFSDFSDF", "Begin the timer!", "Squeeze the Day!", "No time to cit(rus) around!", 
"Lime 'em up, knock 'em down!",
"When life gives you limes, give the limes guns.",
"I had this classmate in high school who took a tupperware of sliced limes to 
school every day and ate them in class. Seriously, she'd take a 
quarter of a raw, unsweeted lime and just bite into it. Like, she probably could
have eaten them like oranges, peeling them and taking out the segments, but she
didn't. Also she hated my guts for some reason. Anyway, want one?"]

# Called when the node enters the scene tree for the first time.
func _ready():
	#Declare array sizes
	for i in range(boundX):
		tiledNodes.append([])
		for j in range(boundY):
			tiledNodes[i].append(null)
	$CutsceneCamera.enabled = true #The camera starts the game inactive.
	setup()
	$Control/Button.text = puns[day + 1]
	call_deferred("nightOver")

func setup():
	Global.limes = initLimes
	Global.seeds = initSeeds
	day = -1

func reset():
	isDay = false
	clear.emit()
	for i in range(boundX):
		for j in range(boundY):
			if tiledNodes[i][j] != null:
				tiledNodes[i][j].health = 0
				tiledNodes[i][j] = null
	
	setup()

func _process(delta):
	if isDay:
		$Control/dayTimer.value -= delta
		
		if $Control/dayTimer.value <= 0:
			$AnimationPlayer.play("startOfNight")
			isDay = false

func start_day():
	$AnimationPlayer.play("startOfDay")
	Global.Daytime.emit()
	$Control/dayTimer.max_value = dayLength
	$Control/dayTimer.value = dayLength
	$Control/Button.text = puns[day + 1]
	isDay = true #for timer purposes
	
	#$Player.position = some starting point to be decided (use a marker2D)

func start_night(): #Begin spawning enemies, etc.
	Global.Nighttime.emit()
#
#func _unhandled_input(event):
	#if event.is_action_pressed("test0"):
		#$AnimationPlayer.play("endOfNight")
##	if Input.is_action_just_pressed("test5"):
##		$AnimationPlayer.play("Loss")
	#if event.is_action_pressed("test3"):
		#$AnimationPlayer.play("Win")

func _on_coord_select(coords):
	selPos = coords
	$indicator.position = $Tiles.map_to_local(selPos)

func _on_player_planted(coords):
	var instance = plant.instantiate()
	$Tiles.add_child(instance)
	instance.position = $Tiles.map_to_local(coords)
	tiledNodes[coords.x][coords.y] = instance
	
	Global.seeds -= Global.plantCost
	$Control/counters/SeedCount.text = str(Global.seeds)

func _on_player_turreted(coords):
	var instance = turret.instantiate()
	$Tiles.add_child(instance)
	instance.position = $Tiles.map_to_local(coords)
	tiledNodes[coords.x][coords.y] = instance
	
	Global.limes -= Global.turretCost
	$Control/counters/LimeCount.text = str(Global.limes)

func _on_player_unplanted(coords):
	tiledNodes[coords.x][coords.y].health = 0
	Global.seeds += 1
	$Control/counters/SeedCount.text = str(Global.seeds)


func _on_player_harvested(coords):
	Global.limes += tiledNodes[coords.x][coords.y].profit
	tiledNodes[coords.x][coords.y].health = 0
	$Control/counters/LimeCount.text = str(Global.limes)

func play_TMG_credit():
	$"AnimationPlayer".play("TheMagmaPsychicCredits")

func _enemy_down(instance):
	livingEnems -= 1
	enemArray.pop_at(enemArray.find(instance))
	if livingEnems <= 0: #If the enemies are wiped out
		$Control/Button.text = puns[day + 1]
		call_deferred(nightOver())

func nightOver():
	day += 1
	if lastDay == day: #If this is going to be the last day
		$AnimationPlayer.play("Win")
	else: #This is not the last day
		if lastDay - day > 1:
			$Control/DayCount.text = "[center]The stars will alime in [color=#00FF00]%s days[/color][/center]" %[lastDay - day]
		else:
			$Control/DayCount.text = "[center]The stars will alime in [color=#00FF00]1 day[/color][/center]"
		var center = (960 - $Control/Button.size.x) / 2
		$AnimationPlayer.get_animation("endOfNight").track_set_key_value(6, 1, Vector2(center, 260))
		$AnimationPlayer.get_animation("endOfNight").track_set_key_value(6, 1, Vector2(center, 260))
		$AnimationPlayer.get_animation("endOfNight").track_set_key_value(6, 2, Vector2(center, 360))
		$Control/counters/LimeCount.text = str(Global.limes)
		$Control/counters/SeedCount.text = str(Global.seeds)
		$AnimationPlayer.play("endOfNight")
