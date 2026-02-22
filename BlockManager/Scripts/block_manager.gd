class_name BlockManager extends Node2D

var block_queue: BlockQueue = BlockQueue.new()

func test() -> void:
	EventBus.move_request.emit()
	#EventBus.move_requested()
	pass
	

@onready var timer = $Timer
var currentStep = 0

func _ready() -> void:
	EventBus.block_added.connect(_on_block_added)
	timer.wait_time = 0.5

var playing = false
func _on_play_button_pressed() -> void:
	playing = !playing
	if blocks.size() == 0: #cannot play with zero blocks - ben
		playing = false
	print("playing", playing)
	IntermediaryMangager.playing = playing
	$Control/PausePlay.set_frame(playing)
	if playing:
		_on_timer_timeout()
		timer.start()
		
	else:
		timer.stop()
	

class blockData:
	var id: int
	var value: Vector2
	var rank: int
	var node: Node

var blocks: Array[blockData] = []

func safe_reparent(child: Node, new_parent: Node):
	if child == new_parent:
		return
	
	# Prevent cyclic parenting
	if new_parent.is_ancestor_of(child):
		return
	
	child.reparent(new_parent)

func _on_block_added(id: int, value: Vector2, rank: int, node: Node):
	
	#if rank > blocks.size() || blocks.size() == 0: #readjusts blocks array to maintain accuracy - ben
	blocks.append(blockData.new())
	#elif blocks[rank].node == node:#avoids duplicating node (when node is modified) - ben
		#pass
	#else:
		#blocks.insert(rank, blockData.new())
		#if blocks[rank + 1].node:
			#call_deferred("safe_reparent", blocks[rank + 1].node, node)
		#blocks[rank+1].node.global_position = node.get_child(0).global_position#the 0 is the first block which has to be ConnectNextBlockDetector  - Ben  
	
	blocks[rank].id = id
	blocks[rank].value = value
	blocks[rank].rank = rank
	blocks[rank].node = node
	
	print("blocks", blocks.size())
	


func _on_timer_timeout() -> void:
	var id = blocks[currentStep].id
	var value = blocks[currentStep].value
	#var rank = blocks[currentStep].rank
	#var node = blocks[currentStep].node
	currentStep += 1
	
	if currentStep > blocks.size() - 1: #loops the code blocks
		currentStep = 0
	
	if id == 1: #block is a MoveBlock
		if value.y == 0:
			IntermediaryMangager.movementDirection.x = value.x
		else:
			IntermediaryMangager.movementDirection.y = value.y
	
	#IntermediaryMangager.movementDirection = value
	#print(value)
	#print(IntermediaryMangager.movementDirection)
