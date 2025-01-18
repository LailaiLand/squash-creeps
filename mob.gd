extends CharacterBody3D

# tilfeldig hastihetsspenn
@export var min_speed = 10
@export var max_speed = 18

func _physics_process(delta):
	move_and_slide()
