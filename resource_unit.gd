extends Sprite2D
class_name ResourceUnit

enum ResourceType {
	resource,
	deposit
}

@export var action_location : Node2D
@export var gather_type : ResourceType
