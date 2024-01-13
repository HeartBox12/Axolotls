extends Node2D
@export var facing:int = 0 #clockwise, 0 is right, 4 is up.
var input:Vector2 = Vector2(0, 0) #Unit vector representing player movement dir

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	input = Vector2(0, 0) #Reset
	
	#Read keyboard/controller. Accounts for weird input and < 1 controller tilt.
	input.y += Input.get_action_strength("move_down")
	input.y -= Input.get_action_strength("move_up")
	input.x += Input.get_action_strength("move_right")
	input.x -= Input.get_action_strength("move_left")
	if input.length() > 1:
		input = input.normalized() #input is now ready to go!
	
	input.angle()

func _physics_process(delta):
	pass
