extends CharacterBody3D

#signal kan hentes ut i node tab og kobles med script i andre scener
signal squashed

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
	# justerer animasjonshastigheten basert på hvor fort den svømmer
	$AnimationPlayer.speed_scale = random_speed / min_speed
	
#trigges i player script når vi hopper på fiender
func squash() -> void:
	#sender signal om å trigge hva squashed er koblet til
	squashed.emit()
	#sletter instansen av mob fra minne
	queue_free()
#greit at de er slettet når de går off screen
#tror jeg skal legge inn en kill field itf de bommer på skjermen
func _on_visible_on_screen_notifier_3d_screen_exited():
	queue_free()
