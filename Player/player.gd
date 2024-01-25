extends Node2D

@export var root:Node
@export var tileSet:Node

@export var walkSpeed:int

signal coordSelect
signal planted
signal turreted
signal unplanted
signal harvested

signal reqPlant #Requesting to plant
signal reqTurret #Requesting to make turret

var canMove:bool = false
var input:Vector2 = Vector2(0, 0) #Unit vector representing player movement dir
var facing:int = 1 #clockwise, 0 is right, 3 is up.
var selPos:Vector2i # The currently selected tile coordinates
var validSelect:bool #Whether that tile is in-range. More checks are needed

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	input = Vector2(0, 0) #Reset
	if !canMove: #TODO: IF THERE IS A BUG, REMOVE THIS STATEMENT. 
		#Better to move while zooming than not be able to move when you should
		return
	
	#Read keyboard/controller. Accounts for weird input and < 1 controller tilt.
	input.y += Input.get_action_strength("move_down")
	input.y -= Input.get_action_strength("move_up")
	input.x += Input.get_action_strength("move_right")
	input.x -= Input.get_action_strength("move_left")
	if input.length() > 1:
		input = input.normalized() #input is now ready to go!
	
	if input != Vector2(0, 0):
		#Determine facing. Prioritize left and right over up and down.
		if input.x > 0:
			$sprite.flip_h = false
			facing = 0
		elif input.x < 0:
			$sprite.flip_h = true
			facing = 2
		elif input.y < 0:
			facing = 3 #facing up (away)
		else:
			facing = 1 #facing down (towards)

func _physics_process(_delta):
	pass

func _reset(): #Yeah I know this is jank as hell.
	$"State Machine".on_swap($"State Machine".currentState, "offscreen")

func _set_coord_valid(value:bool):
	validSelect = value

func _set_idle(): #For use in the tutorial
	$"State Machine".on_swap($"State Machine/offscreen", "idle")

func _set_plant(): #For use when attempting to build
	$"State Machine".on_swap($"State Machine/idle", "plant")

func _set_harvest():
	$"State Machine".on_swap($"State Machine/idle", "harvest")

func _set_unplant():
	$"State Machine".on_swap($"State Machine/idle", "unplant")

func _set_turret():
	$"State Machine".on_swap($"State Machine/idle", "turret")

func toggleMove():
	canMove = !canMove
