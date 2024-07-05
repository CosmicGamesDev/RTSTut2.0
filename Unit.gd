extends CharacterBody2D

@export var speed = 400

var target = position + Vector2(200,200)
@onready var sprite_2d = $Sprite2D
var is_selected = false

@onready var animation_player = $AnimationPlayer

func _ready():
	SelectionManager.do_action.connect(_on_do_action)

func _physics_process(delta):
	velocity = position.direction_to(target) * speed
	if velocity.x > 0:
		sprite_2d.flip_h = false
	else:
		sprite_2d.flip_h = true
	if position.distance_to(target) > 10:
		move_and_slide()
		animation_player.play("walk")
	else:
		animation_player.play("idle")

func select():
	is_selected = true
	sprite_2d.material.set_shader_parameter("thickness", 2)

func unselect():
	is_selected = false
	sprite_2d.material.set_shader_parameter("thickness", 0)

func _on_do_action(position: Vector2, state: SelectionManager.ACTION_STATES):
	if is_selected:
		target = position
