extends RigidBody2D

func _on_platform_collider_body_entered(body: Node2D) -> void:
	if body.get_parent().name == "platforms":
		linear_velocity.y = .1		
