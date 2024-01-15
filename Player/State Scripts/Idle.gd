extends State
@export var host:Node
@export var machine:Node
@export var sprite:Node

var playerPos

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
	host.selPos = playerPos
	
	match host.facing:
		0:
			host.selPos.x += 1
		1:
			host.selPos.y += 1
		2:
			host.selPos.x -= 1
		3:
			host.selPos.y -= 1
	host.validSelect = host.tileSet.get_cell_tile_data(0, host.selPos).get_custom_data("valid")
	
	if host.validSelect:
		host.coordSelect.emit(host.selPos)
	
	if Input.is_action_just_pressed("interact_plant") && host.validSelect:
		swap.emit(self, "plant")

func physics_update(_delta): #Equivalent to func physics_process() in the host.
	pass
