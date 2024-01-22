extends State
@export var host:Node
@export var machine:Node
@export var sprite:Node

var playerPos

func enter(): #When this state is entered
	sprite.play("idle")
	#match host.facing: #Sprite Assign
		#0:
			#sprite.play("idle_right")
		#1:
			#sprite.play("idle_down")
		#2:
			#sprite.play("idle_left")
		#3:
			#sprite.play("idle_up")
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
	
	if Input.is_action_just_pressed("interact_plant"):
		host.reqPlant.emit(host.selPos)
		
		#var target = host.root.tiledNodes[host.selPos.x][host.selPos.y]
		#if  target == null: #Trying to plant on empty tile
			#if Global.seeds >= Global.plantCost:
				#swap.emit(self, "plant")
			#else:
				#pass
		#elif !target.is_in_group("plants"): #Not a plant
			#pass
		#elif target.profit > 0: #Ripe/mature plant
			#swap.emit(self, "harvest") #pick the plant
		#else:
			#swap.emit(self, "unplant")
		
	if Input.is_action_just_pressed("interact_turret"):
		host.reqTurret.emit(host.selPos)

func physics_update(_delta): #Equivalent to func physics_process() in the host.
	pass
