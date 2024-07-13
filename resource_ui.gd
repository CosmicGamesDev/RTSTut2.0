extends CanvasLayer

var gold_amount = 0
@onready var label = $Control/Label

# Called when the node enters the scene tree for the first time.
func _ready():
	label.text = str(gold_amount)
	ResourceManager.add_resource.connect(_on_add_resource)
	ResourceManager.subtract_resource.connect(_on_subtract_resource)


func _on_add_resource(amount):
	gold_amount += amount
	label.text = str(gold_amount)

func _on_subtract_resource(amount):
	if gold_amount - amount < 0:
		return
	gold_amount -= amount
	label.text = str(gold_amount)
