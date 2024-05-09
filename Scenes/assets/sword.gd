extends Node3D

@onready var anim_player = $AnimationPlayer
@onready var sound = $AudioStreamPlayer

signal enable_hit_box
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func attack():
	
	sound.play()
	anim_player.play("attack")
	
func damage():
	emit_signal("enable_hit_box")
	
