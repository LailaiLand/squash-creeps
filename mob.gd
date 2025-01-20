extends CharacterBody3D

# tilfeldig hastihetsspenn
#ikke sikker på hvorfor export
@export var min_speed = 10
@export var max_speed = 18

func _physics_process(_delta):
	move_and_slide()

func initialize(start_position, player_position):
	#vet fortsatt ikke hvor vi får variebler fra
	#eller hvorfor vector3UP
	#WAIT... Denne skal kalles fra Main, så start og player blir nodes
	#veldig uintuitivt om jeg ikke hadde litt forkunnskaper.....
	#er V3.UP aksen den roteres rundt? :0 
	look_at_from_position(start_position, player_position, Vector3.UP)
	#radianer >:0
	rotate_y(randf_range(-PI / 4, PI / 4))
	
	var random_speed = randi_range(min_speed, max_speed)
	#jeg tror jeg byner å skjønne Vector3 litt bedre.
	#den sier hvilken retning ift objoektet ting er
	velocity = Vector3.FORWARD * random_speed
	#Trodde jeg?
	#Men så må den totere hastigheten så det passer objektet?
	#Trodde den skulle få det fra V3.FORW?
	#Ah, Vector3 er *global* og vi fikk rotasjonen i relasjon til player tidligere
	#Så da må velocity som er *lokal* dreies til å matche
	velocity = velocity.rotated(Vector3.UP, rotation.y)
	
#greit at de er slettet når de går off screen
#tror jeg skal legge inn en kill field itf de bommer på skjermen
func _on_visible_on_screen_notifier_3d_screen_exited():
	queue_free()
