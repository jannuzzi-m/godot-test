extends CharacterBody3D


const SPEED = 15.0
const JUMP_VELOCITY = 10
const SENSITIVITY = 0.003
const STAGGER_FORCE = 160
signal player_hit
signal player_heal
signal player_killed

var health = 3

var can_attack = true

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = 15
@onready var head := $Head
@onready var camera := $Head/Camera3D
@onready var weapon := $Head/Camera3D/sword
@onready var weapon_hit_box := $Head/Camera3D/sword/hitbox

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _unhandled_input(event):
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * SENSITIVITY);
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-89), deg_to_rad(89))
	
func _physics_process(delta):
	if health <= 0:
		emit_signal("player_killed")
		return
		
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
		
	if global_position.y < -30:
		position = Vector3(0, 10, 0)
		

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	if Input.is_action_just_pressed("attack"):
		if can_attack:
			weapon.attack()
			can_attack = false
			$CoolDown.start()
			

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "forward", "back")
	var direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
	
func damage(direction):
	velocity += Vector3(direction.x, .01, direction.z) * STAGGER_FORCE
	health -= 1
	emit_signal("player_hit")

func _on_sword_enable_hit_box():
	var bodies = weapon_hit_box.get_overlapping_bodies()
	for body in bodies:
		if body.has_method("damage_enemy"):
			body.damage_enemy()

func heal():
	health += 1
	emit_signal("player_heal")


func _on_timer_timeout():
	can_attack = true
