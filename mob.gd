extends CharacterBody3D

# tilfeldig hastihetsspenn
#ikke sikker på hvorfor export
@export var min_speed = 10
@export var max_speed = 18

func _physics_process(_delta):
	move_and_slide()

#position params kommer fra main scene når den kjører denne i packed instance
func initialize(start_position, player_position):
	#Vector3 er global, så den sier ar det skal roteres rundt aksen oppover
	look_at_from_position(start_position, player_position, Vector3.UP)
	#radianer >:0
	rotate_y(randf_range(-PI / 4, PI / 4))
	
	var random_speed = randi_range(min_speed, max_speed)
	#setter en retning og ganger med tall for å gi den en fart i det heletatt
	velocity = Vector3.FORWARD * random_speed
	#så troterer vi den farta så den har samme rotasjon som rotation
	velocity = velocity.rotated(Vector3.UP, rotation.y)
	
#jeg har ikke kommet hit i tutorialen enda, regner med den skal sende point increase signal også etterhvert.
func squash() -> void:
	queue_free()
#greit at de er slettet når de går off screen
#tror jeg skal legge inn en kill field itf de bommer på skjermen
func _on_visible_on_screen_notifier_3d_screen_exited():
	queue_free()
