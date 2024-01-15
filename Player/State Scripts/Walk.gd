extends State
@export var host:Node
@export var machine:Node
@export var sprite:Node

var playerPos


func enter(): #When this state is entered
	pass
	
func exit(): #Just before this state is exited
	pass

func update(_delta): #Equivalent to func process(delta) in the host. Only use process() to call this
	match host.facing: #Sprite Assign
		0:
			sprite.animation = "walk_right"
		1:
			sprite.animation = "walk_down"
		2:
			sprite.animation = "walk_left"
		3:
			sprite.animation = "walk_up"
	
	if host.input == Vector2(0, 0):
		swap.emit(self, "idle")
		
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
	#Change sprite to walk
	#Start playing if needed

func physics_update(delta): #Equivalent to func physics_process() in the host.
	host.velocity = host.input * host.walkSpeed * delta
	host.move_and_slide()
