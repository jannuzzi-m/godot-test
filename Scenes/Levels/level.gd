extends Node3D

signal handle_pause
signal enemy_killed

var paused = false;

@onready var spawns = $Map/Spawns
@onready var map = $Map
@onready var spawn_timer = $Map/SpawnTimer
@onready var hud = $Hud

var enemy = load("res://Scenes/assets/enemy.tscn")
var instance
var enemies_killeds = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_handle_pause()
		
func _handle_pause():
	if Input.is_action_just_pressed("Pause"):
		if get_tree().paused:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			get_tree().paused = false
			emit_signal("handle_pause", false)			
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			get_tree().paused = true
			emit_signal("handle_pause", true)
			
func get_random_child(parent_node):
	var random_id = randi() % parent_node.get_child_count()
	return parent_node.get_child(random_id)

func _on_spawn_timer_timeout():
	var spawn_point = get_random_child(spawns).global_position
	instance = enemy.instantiate()
	instance.position = spawn_point
	map.add_child(instance)	
	instance.connect("enemy_died", _on_enemy_died)
	
func _on_enemy_died():
	enemies_killeds += 1
	emit_signal("enemy_killed", enemies_killeds)

	
