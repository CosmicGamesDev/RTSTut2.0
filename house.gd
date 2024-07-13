extends ResourceUnit

@onready var animation_player = $AnimationPlayer
@onready var collision_shape_2d = $BuildArea/CollisionShape2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_build_area_build_finished():
	collision_shape_2d.disabled
	animation_player.play("built")
