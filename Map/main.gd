extends Node2D

signal daytime #Connects to plants to tell them to ripen.
signal clear #Connects to enemies so the script can wipe them out

signal coordValid

signal setTurret
signal setPlant
signal setUnplant
signal setHarvest
signal finished

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
var livingEnems:int = 6 #Living enemies. When it reaches 0, start day. FIXME: set 0.
var enemArray = []
var charZoom:bool = true

var validTarget:bool #Whether the player is looking at a valid tile for placement

var puns = ["Begin the timer!", "Squeeze the Day!", "No time to cit(rus) around!", 
"Lime 'em up, knock 'em down!",
"When life gives you limes, give the limes guns.",
"Lemons are just sublimes",
"I had this classmate in high school who took a tupperware of sliced limes to 
school every day and ate them in class. Seriously, she'd take a 
quarter of a raw, unsweeted lime and just bite into it. Like, she probably could
have eaten them like oranges, peeling them and taking out the segments, but she
didn't. Also she hated my guts for some reason. Anyway, want one?", "Fulfill your zestiny!"]

# Called when the node enters the scene tree for the first time.
func _load():
	#Declare array sizes
	for i in range(boundX):
		tiledNodes.append([])
		for j in range(boundY):
			tiledNodes[i].append(null)
	$Camera.enabled = true #The camera starts the game inactive.
	setup()

func setup():
	Global.limes = initLimes
	Global.seeds = initSeeds
	Global.turrPriceInd = 0
	day = -1
	$UI/Control/Button.text = puns[day + 1]
	$UI/Control/counters/TurretCost.text = str(Global.turretPrices[Global.turrPriceInd])
	$UI/Control/dayTimer.value = $UI/Control/dayTimer.max_value
	
	call_deferred("nightOver")

func reset():
	isDay = false
	clear.emit()
	for i in range(boundX):
		for j in range(boundY):
			if tiledNodes[i][j] != null:
				tiledNodes[i][j].remove() #This is still not the right way.
				tiledNodes[i][j] = null

func _on_shrine_destroyed(): #The player let the shrine get defaced. They lose.
	$Camera.enabled = false
	$UI.visible = false
	finished.emit()
	#$AnimationPlayer.queue("Loss")

func _process(delta):
	if isDay:
		$UI/Control/dayTimer.value -= delta
		if $UI/Control/dayTimer.value >= 1 && $UI/Control/dayTimer.value <= 2:
			$UI/Control/Button.text = puns[day]
		if $UI/Control/dayTimer.value <= 0:
			zoomOut()
			$AnimationPlayer.queue("startOfNight")
			isDay = false
	
	if Input.is_action_just_pressed("reset"):
		_on_shrine_destroyed()
	
	if Input.is_action_just_pressed("skip_day") && isDay:
		zoomOut()
		$AnimationPlayer.queue("startOfNight")
		isDay = false
	
	if charZoom:
		$Camera.position = $Player.position


func _day_button_pressed():
	if lastDay + 1 == day:
		modulate = Color("ffffff")
		$AnimationPlayer.queue("Win")
	else:
		start_day()

func start_day():
	zoomIn()
	$AnimationPlayer.queue("startOfDay")
	Global.Daytime.emit()
	if day != 0 && day != 5:
		Global.seeds += 1
		$UI/Control/counters/SeedCount.text = str(Global.seeds)
	$UI/Control/dayTimer.max_value = dayLength
	$UI/Control/dayTimer.value = dayLength
	isDay = true #for timer purposes
	
	livingEnems = ($spawner.leftSpawns.size() + $spawner.bottomSpawns.size() + $spawner.rightSpawns.size())
	
	#$Player.position = some starting point to be decided (use a marker2D)

func start_night(): #Begin spawning enemies, etc.
	Global.Nighttime.emit()

func _on_coord_select(coords):
	if coords != null: #Player node actually transmitted coords
		$indicator.visible = true
		selPos = coords
		
		#Tile is dirt, can be selected
		if selPos.x > 1 && selPos.x < 28 && selPos.y > 3 && selPos.y < 15:
		#if $Tiles.get_cell_tile_data(0, selPos).get_custom_data("valid"):
			$indicator.position = $Tiles.map_to_local(selPos)
			validTarget = true
			
		else: #Tile is grass, cannot be selected
			$indicator.position = $Tiles.map_to_local(Vector2(-1, -1))
			validTarget = false
			
	else: #Null indicating "I want to select nothing!" (offscreen state)
		validTarget = false
		$indicator.visible = false
		coordValid.emit(validTarget)

func _on_player_planted(coords): #player transmits after completed planting
	if selPos.x > 1 && selPos.x < 28 && selPos.y > 3 && selPos.y < 15:
		pass
	else:
		return
	var instance = plant.instantiate()
	$Tiles.add_child(instance)
	instance.position = $Tiles.map_to_local(coords)
	tiledNodes[coords.x][coords.y] = instance
	
	Global.seeds -= Global.plantCost
	$UI/Control/counters/SeedCount.text = str(Global.seeds)
	
	instance.destroyed.connect(_plant_down)
	
	if $Tiles.get_cell_tile_data(0, coords, false).get_terrain() == 0:
		pass
	else:
		$Tiles.set_cells_terrain_connect(0, [coords], 0, 0, true)

func _on_player_turreted(coords): #Player places a turret at coords
	if selPos.x > 1 && selPos.x < 28 && selPos.y > 3 && selPos.y < 15:
		pass
	else:
		return
	var instance = turret.instantiate()
	$Tiles.add_child(instance)
	instance.position = $Tiles.map_to_local(coords)
	tiledNodes[coords.x][coords.y] = instance
	
	Global.limes -= Global.turretPrices[Global.turrPriceInd]
	$UI/Control/counters/LimeCount.text = str(Global.limes)
	
	if Global.turrPriceInd < Global.turretPrices.size() - 1:
		Global.turrPriceInd += 1
		$UI/Control/counters/TurretCost.text = str(Global.turretPrices[Global.turrPriceInd])

func _on_player_unplanted(coords): #Player uproots a plant at coords
	tiledNodes[coords.x][coords.y].health = 0


func _on_player_harvested(coords): #Player harvests a plant at coords
	Global.limes += tiledNodes[coords.x][coords.y].profit
	tiledNodes[coords.x][coords.y].remove()
	$UI/Control/counters/LimeCount.text = str(Global.limes)

func play_TMG_credit():
	$"AnimationPlayer".queue("TheMagmaPsychicCredits")

func _enemy_down(instance):
	livingEnems -= 1
	enemArray.pop_at(enemArray.find(instance))
	if livingEnems <= 0: #If the enemies are wiped out
		nightOver()
	
func _plant_down(): #called by plant.destroyed
	Global.seeds += 1
	$UI/Control/counters/SeedCount.text = str(Global.seeds)
	

func nightOver():
	day += 1
	if lastDay == day: #If this is going to be the last day
		var center = (960 - $UI/Control/Button.size.x) / 2
		$AnimationPlayer.get_animation("endOfNight").track_set_key_value(6, 1, Vector2(center, 260))
		$AnimationPlayer.get_animation("endOfNight").track_set_key_value(6, 1, Vector2(center, 260))
		$AnimationPlayer.get_animation("endOfNight").track_set_key_value(6, 2, Vector2(center, 360))
		$UI/Control/DayCount.text = "
[center]The stars have alimed.
Fulfull your zestiny.[/center]" #Note: might make this value-setting part of anim
		modulate = Color("ffffff")
		$AnimationPlayer.queue("Win")
	else: #This is not the last day
		if lastDay - day > 1:
			$UI/Control/DayCount.text = "[center]The stars will alime in [color=#00FF00]%s days[/color][/center]" %[lastDay - day]
		else:
			$UI/Control/DayCount.text = "[center]The stars will alime in [color=#00FF00]1 day[/color][/center]"
		var center = (960 - $UI/Control/Button.size.x) / 2
		$AnimationPlayer.get_animation("endOfNight").track_set_key_value(6, 1, Vector2(center, 260))
		$AnimationPlayer.get_animation("endOfNight").track_set_key_value(6, 1, Vector2(center, 260))
		$AnimationPlayer.get_animation("endOfNight").track_set_key_value(6, 2, Vector2(center, 360))
		$UI/Control/counters/LimeCount.text = str(Global.limes)
		$UI/Control/counters/SeedCount.text = str(Global.seeds)
		$AnimationPlayer.queue("endOfNight")

func zoomIn():
	$Camera.set_limit(SIDE_TOP, 0)
	$AnimationPlayer.get_animation("Zoom").track_set_key_value(1, 0, Vector2(480, 270)) #sets beginning position keyframe to center of screen
	$AnimationPlayer.get_animation("Zoom").track_set_key_value(1, 1, $Player.position) #sets end position keyframe to player position
	$AnimationPlayer.get_animation("Zoom").track_set_key_value(0, 0, Vector2(1, 1)) #sets beginning zoom to full
	$AnimationPlayer.get_animation("Zoom").track_set_key_value(0, 1, Vector2(2, 2)) #sets end zoom to double
	$AnimationPlayer.play("Zoom")
	charZoom = true

func zoomOut():
	$Camera.set_limit(SIDE_TOP, -540)
	$AnimationPlayer.get_animation("Zoom").track_set_key_value(1, 0, $Camera.position) #sets beginning position keyframe to player position
	$AnimationPlayer.get_animation("Zoom").track_set_key_value(1, 1, Vector2(480, 270)) #sets end position keyframe to center of screen
	$AnimationPlayer.get_animation("Zoom").track_set_key_value(0, 0, Vector2(2, 2)) #sets beginning zoom to double
	$AnimationPlayer.get_animation("Zoom").track_set_key_value(0, 1, Vector2(1, 1)) #sets end zoom to full
	$AnimationPlayer.play("Zoom")
	charZoom = false


func _on_player_reqPlant(coords): #When the player requests a plant action.
	var target = tiledNodes[coords.x][coords.y]
	
	#Elif statement to ascertain what the player is trying to do
	if  target == null: #Trying to plant on empty tile
		if Global.seeds >= Global.plantCost:
			setPlant.emit()
		else:
			pass
	elif !target.is_in_group("plants"): #Not a plant
		pass
	elif target.profit > 0: #Ripe/mature plant
		setHarvest.emit()
	else:
		setUnplant.emit()

func _on_player_reqTurret(coords): #When the player requests a build action.
	var target = tiledNodes[coords.x][coords.y]
	
	if target == null && Global.limes >= Global.turretPrices[Global.turrPriceInd]: #If there's room...
		setTurret.emit()
