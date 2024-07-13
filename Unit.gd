extends CharacterBody2D


const SPEED = 300
var is_selected = false
var state := SelectionManager.ACTION_STATES.idle
var current_interactive_obj = Node2D.new()
var previous_interactive_obj = Node2D.new()
var is_building = false
@onready var sprite_2d = $Sprite2D
@onready var nav_agent = $NavigationAgent2D
@onready var animation_player = $AnimationPlayer
@onready var resource_sprite = $WorkArea/ResourceSprite

func _ready():
	nav_agent.navigation_finished.connect(_on_nav_finished)
	nav_agent.velocity_computed.connect(_on_navigation_agent_2d_velocity_computed)
	SelectionManager.do_action.connect(_on_do_action)

func _physics_process(delta):
	var next_path_pos = nav_agent.get_next_path_position()
	var direction := global_position.direction_to(next_path_pos)
	var new_velocity = direction * SPEED
	if new_velocity != Vector2.ZERO and !is_building:
		animation_player.play("walk")
	elif !is_building:
		animation_player.play("idle")
	nav_agent.velocity = new_velocity
	if new_velocity.x > 0:
		sprite_2d.flip_h = false
	elif new_velocity.x < 0:
		sprite_2d.flip_h = true

func select():
	is_selected = true
	sprite_2d.material.set_shader_parameter("thickness", 2)

func unselect():
	is_selected = false
	sprite_2d.material.set_shader_parameter("thickness", 0)

func _on_do_action(position: Vector2, action_state: SelectionManager.ACTION_STATES, interactive_object = null):
	if is_selected and action_state == SelectionManager.ACTION_STATES.move:
		makepath(position)
		state = action_state
	if is_selected and action_state == SelectionManager.ACTION_STATES.build and interactive_object != null:
		makepath(position)
		state = action_state
		current_interactive_obj = interactive_object
	if is_selected and action_state == SelectionManager.ACTION_STATES.gather and interactive_object != null:
		makepath(position)
		state = action_state
		current_interactive_obj = interactive_object

func makepath(pos: Vector2):
	nav_agent.target_position = pos

func build():
	is_building = true
	animation_player.play("build")
	makepath(global_position)

func gather(gather_type):
	if gather_type == ResourceUnit.ResourceType.resource:
		resource_sprite.visible = true
		previous_interactive_obj = current_interactive_obj
		current_interactive_obj = get_nearest_castle()
		makepath(current_interactive_obj.global_position)
	elif gather_type == ResourceUnit.ResourceType.deposit:
		ResourceManager.add(1)
		resource_sprite.visible = false
		current_interactive_obj = previous_interactive_obj
		makepath(current_interactive_obj.action_location.global_position)
	

func get_nearest_castle():
	var nearest_castle = get_tree().get_first_node_in_group("castle")
	
	return nearest_castle

func stop():
	state = SelectionManager.ACTION_STATES.idle
	is_building = false

func _on_nav_finished():
	makepath(global_position)
	if !is_building:
		animation_player.play("idle")

func _on_navigation_agent_2d_velocity_computed(safe_velocity):
	velocity = velocity.move_toward(safe_velocity, 100)
	move_and_slide()
