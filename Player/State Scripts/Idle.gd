extends State
@export var host:Node
@export var machine:Node
@export var sprite:Node

var playerPos
var lookPos #The currently selected tile. -1, -1 means invalid
var selPos
var validSelect:bool

func enter(): #When this state is entered
	match host.facing: #Sprite Assign
		0:
			sprite.animation = "idle_right"
		1:
			sprite.animation = "idle_down"
		2:
			sprite.animation = "idle_left"
		3:
			sprite.animation = "idle_up"
	#Change sprite to idle
	#Start playing if needed
	
func exit(): #Just before this state is exited
	pass

func update(_delta): #Equivalent to func process(delta) in the host. Only use process() to call this
	if host.input != Vector2(0, 0):
		swap.emit(self, "walk")
	
	playerPos = host.tileSet.local_to_map(host.position)
	lookPos = playerPos
	
	match host.facing:
		0:
			lookPos.x += 1
		1:
			lookPos.y += 1
		2:
			lookPos.x -= 1
		3:
			lookPos.y -= 1
	validSelect = host.tileSet.get_cell_tile_data(0, lookPos).get_custom_data("valid")
	
	if validSelect:
		host.coordSelect.emit(lookPos)
	
	if Input.is_action_just_pressed("interact_plant"):
		host.tileSet

func physics_update(_delta): #Equivalent to func physics_process() in the host.
	pass
