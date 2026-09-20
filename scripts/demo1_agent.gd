extends CharacterBody3D

const SPEED = 5.0

@export var movement_target: Node3D
@onready var navigation_agent: NavigationAgent3D = $NavigationAgent3D

func _ready():
	# Godot 4 yêu cầu chờ 1 physics frame trước khi tính toán đường đi để NavigationServer có thời gian đồng bộ các lưới điều hướng trên bản đồ
	call_deferred("setup")

func setup():
	await get_tree().physics_frame
	if movement_target:
		print("vi tri target: ", movement_target.global_position)
		set_movement_target(movement_target.global_position)
	else:
		print("Khong co target")

func set_movement_target(target_pos: Vector3):
	navigation_agent.target_position = target_pos
	print("diem den cho agent: ", target_pos)
	print("duong di duoc tao ra: ", navigation_agent.get_current_navigation_path())

func _physics_process(delta):
	if navigation_agent.is_navigation_finished():
		return
		
	if navigation_agent.get_current_navigation_path().is_empty():
		# Nếu chưa có đường đi có thể do map chưa load kịp, thử set lại target
		if movement_target:
			set_movement_target(movement_target.global_position)
		return

	var current_agent_position: Vector3 = global_position
	var next_path_position: Vector3 = navigation_agent.get_next_path_position()
	
	var new_velocity: Vector3 = current_agent_position.direction_to(next_path_position) * SPEED
	
	if Engine.get_process_frames() % 60 == 0:
		print("van toc: ", new_velocity, ", khoang cach toi diem ke: ", current_agent_position.distance_to(next_path_position))
	
	velocity = new_velocity
	move_and_slide()
