extends Node3D

@onready var region: NavigationRegion3D = $NavigationRegion3D
@onready var bridge_a: CSGBox3D = $NavigationRegion3D/Bridge_A
@onready var agent = $Agent
@onready var target: Marker3D = $Target

var is_bridge_broken = false

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept") and not is_bridge_broken:
		is_bridge_broken = true
		print("RẦM! Cây cầu đỏ đã bị đánh sập!")
		
		# 1. Xóa bỏ cầu khỏi thế giới vật lý và đồ họa
		bridge_a.use_collision = false
		bridge_a.visible = false
		
		# 2. Yêu cầu Region quét (bake) lại lưới điều hướng ngay lập tức
		region.bake_navigation_mesh(false)
		
		# 3. Đợi 2 frame để Máy chủ NavigationServer3D đồng bộ bản đồ mới
		await get_tree().physics_frame
		await get_tree().physics_frame
		
		# 4. Ra lệnh cho Agent tìm đường lại từ đầu
		agent.set_movement_target(target.global_position)
		print("Agent đã tính toán lại đường đi vòng qua cầu phụ!")
