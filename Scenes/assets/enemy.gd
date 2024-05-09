extends CharacterBody3D

var player = null
var state_machine

const SPEED = 8.0;
const ATTACK_RANGE = 2.5

signal enemy_died

@export var player_path := "/root/Level/Map/Player"
@onready var nav_agent = $NavigationAgent3D
@onready var anim_tree = $AnimationTree
@onready var hitbox = $HitBox
@onready var explostion_sound = $ExplostionSound3d

var hp = 3

func _ready():
	player = get_node(player_path)
	state_machine = anim_tree.get("parameters/playback")
	
func _process(delta):
	if hp <= 0:
		emit_signal("enemy_died")
		queue_free()
	velocity = Vector3.ZERO
	
	match state_machine.get_current_node():
		"Run":
			nav_agent.set_target_position(player.global_transform.origin)
			var next_point = nav_agent.get_next_path_position()
			velocity = (next_point - global_transform.origin).normalized() * SPEED
			look_at(Vector3(global_position.x + velocity.x, global_position.y + velocity.y, global_position.z + velocity.z), Vector3.UP)
		"atack":
			pass
			#look_at(Vector3(global_position.x + velocity.x, global_position.y + velocity.y, global_position.z + velocity.z), Vector3.UP)
	
	anim_tree.set("parameters/conditions/attack", _target_in_range())
	anim_tree.set("parameters/conditions/run", !_target_in_range())
	
	move_and_slide()

func _target_in_range():
	return global_position.distance_to(player.global_position) < ATTACK_RANGE

func attack():
	var bodies = hitbox.get_overlapping_bodies()
	for body in bodies:
		if body.has_method("damage"):
			var dir = global_position.direction_to(player.global_position)
			body.damage(dir)
			
func damage_enemy():
	$Hurt.emitting = true
	hp -= 1


func emition():
	explostion_sound.play()
	$Explostion.emitting = true
