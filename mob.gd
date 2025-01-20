extends CharacterBody3D

# tilfeldig hastihetsspenn
@export var min_speed = 10
@export var max_speed = 18

func _physics_process(_delta):
	move_and_slide()
	
# Jeg tror vi må sende denne ut med signal 
# senere så Main kan kalle på den?
func initialize(start_position, player_position):
	#vet fortsatt ikke hvor vi får variebler fra
	#eller hvorfor vector3UP
	#er V3.UP aksen den roteres rundt? :0 
	look_at_from_position(start_position, player_position, Vector3.UP)
	rotate_y(randf_range(-PI / 4, PI / 4))
	
	var random_speed = randi_range(min_speed, max_speed)
	#jeg tror jeg byner å skjønne Vector3 litt bedre.
	#den sier hvilken retning ift objoektet ting er
	velocity = Vector3.FORWARD * random_speed
	#Trodde jeg?
	#Men så må den totere hastigheten så det passer objektet?
	#Trodde den skulle få det fra V3.FORW?
	velocity = velocity.rotated(Vector3.UP, rotation.y)
	

func _on_visible_on_screen_notifier_3d_screen_exited() -> void:
	pass # Replace with function body.
