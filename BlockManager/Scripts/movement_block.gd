extends Node2D

var buttonHeld = false
@onready var centerOfBlock = $Center.position
var connectToBlock = null
var blockAttachingTo = null

var activated = false
var direction = Vector2.ZERO

var rankInList = -1

func _process(delta: float = 1) -> void:
	if buttonHeld:
		global_position = get_global_mouse_position() - centerOfBlock


func _on_button_button_down() -> void:
	buttonHeld = true
	_process()
	
	rankInList = -1
	print(rankInList)


func _on_button_button_up() -> void:
	buttonHeld = false
	call_deferred("reparent", get_tree().current_scene)
	if connectToBlock != null:
		global_position = connectToBlock
		if blockAttachingTo != null:
			call_deferred("reparent", blockAttachingTo)
			if not (blockAttachingTo is Control):
				if not (blockAttachingTo is Sprite2D):
					rankInList = blockAttachingTo.rankInList + 1
				else:
					rankInList = 0
		if rankInList != -1:
			print("emmiting1")
			EventBus.block_added.emit(1, direction, rankInList, self)


func _on_connect_to_last_detector_area_entered(area: Area2D) -> void:
	#if buttonHeld:
		#return
	if area.is_in_group("ConnectAbove"):
		connectToBlock = area.global_position
		if area.get_parent() == Node2D:
			rankInList = area.get_parent().rankInList + 1
		else:
			rankInList = -1
		blockAttachingTo = area.get_parent()
		print("glitching")

func _on_connect_to_last_detector_area_exited(area: Area2D) -> void: 
	if area.is_in_group("ConnectAbove"):
		connectToBlock = null



func _on_connect_to_next_detector_area_entered(area: Area2D) -> void:# These will be used to register the direction blocks
	if area.is_in_group("ConnectFrom"):
		activated = true
		if area.is_in_group("RightBlock"):
			direction = Vector2.RIGHT
			print("should be working", direction, Vector2.RIGHT)
			if area.get_parent().buttonHeld:
				print("emmiting2")
				EventBus.block_added.emit(1, direction, rankInList, self)


func _on_connect_to_next_detector_area_exited(area: Area2D) -> void:
	if buttonHeld:
		return
	if area.is_in_group("ConnectFrom"):
		activated = false
		direction = Vector2.ZERO
		print("stage1")
		if area.get_parent().buttonHeld:
			print("emmiting3")
			EventBus.block_added.emit(1, direction, rankInList, self)
	
