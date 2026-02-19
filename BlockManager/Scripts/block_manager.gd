class_name BlockManager extends Node2D

var block_queue: BlockQueue = BlockQueue.new()

func test() -> void:
	EventBus.move_request.emit()
	#EventBus.move_requested()
	pass
