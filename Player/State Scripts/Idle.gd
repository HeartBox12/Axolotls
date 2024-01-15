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
	if host.tileSet.get_cell_tile_data(0, host.selPos) != null:
		host.validSelect = host.tileSet.get_cell_tile_data(0, host.selPos).get_custom_data("valid")
	
	if host.validSelect:
		host.coordSelect.emit(host.selPos)
	else:
		host.coordSelect.emit(Vector2i(-1, -1))
	
	if Input.is_action_just_pressed("interact_plant") && host.validSelect:
		var target = host.root.tiledNodes[host.selPos.x][host.selPos.y]
		if  target == null && Global.seeds >= Global.plantCost: #empty tile, can afford plant
			swap.emit(self, "plant")
		elif !target.is_in_group("plants"): #Not a plant
			pass
		elif target.ripe: #Ripe plant
			swap.emit(self, "harvest") #pick the plant
		else:
			swap.emit(self, "unplant")
		
	if Input.is_action_just_pressed("interact_turret") && host.validSelect && host.root.tiledNodes[host.selPos.x][host.selPos.y] == null && Global.limes >= Global.turretCost:
		swap.emit(self, "turret")

func physics_update(_delta): #Equivalent to func physics_process() in the host.
	pass
