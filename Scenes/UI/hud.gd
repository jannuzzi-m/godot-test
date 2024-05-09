extends Control

var player = null
var paused = false
var enemy_killed = false

@export var player_path: NodePath
@onready var container = $HpContainer
@onready var end_game_panel = $EndGame
@onready var pause_menu = $PauseMenu
@onready var cropScene = load("res://Scenes/UI/hearts.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node(player_path)
	for i in range(player.health):
		var newCrop = cropScene.instantiate() #creates a new node
		container.add_child(newCrop) #this

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
		
func _handle_pause():
	pass

	
func _on_player_player_hit():
	var child = container.get_child(0)
	container.remove_child(child)
	print(player.health)

func _on_player_player_heal():
	var newCrop = cropScene.instantiate() #creates a new node
	container.add_child(newCrop) #this


func _on_player_player_killed():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	$EndGame/VBoxContainer/HBoxContainer/count.text = str(enemy_killed)
	end_game_panel.visible = true

func _on_restart_pressed():
	get_tree().reload_current_scene()

func _on_level_handle_pause(paused):
	pause_menu.visible = paused

func _on_continue_pressed():
	pause_menu.visible = false
	get_tree().paused = false


func _on_main_menu_pressed():
	get_tree().change_scene_to_file("res://Scenes/UI/main_menu.tscn")


func _on_level_enemy_killed(count):
	enemy_killed = count
	$HBoxContainer/count.text = str(enemy_killed)
