extends CharacterBody3D

#signal til å trigge events i main scene
signal hit

# @export eksponerer variablene så de kan brukes av andre noder
# hastighet er gitt i m/s
@export var speed = 14
@export var fall_acceleration = 75
@export var jump_impulse = 20
@export var bounce_impulse = 16

# Vector3.ZERO betyr at det står stille. Referansepunkt
var target_velocity = Vector3.ZERO

# Alt som skal bevege seg med fysikk må regne bevegelser i _physics_process.
func _physics_process(delta):
	# direction brukes som en variabel vi kan endre på
	# Vi lar koden endre hastighet basert på direction
	var direction = Vector3.ZERO
	
	# trykk på en knapp for å endre direction riktig vei
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_back"):
		direction.z += 1
	if Input.is_action_pressed("move_forward"):
		direction.z -= 1
	if direction != Vector3.ZERO:
		# normaliserer direction til 1 så vi ikke løper dobbelt så fort på skrå
		direction = direction.normalized()
		# henter looking_at så fysikkmotor kan kalkulere rotering
		$Pivot.basis = Basis.looking_at(direction)
		#bytter animasjonshastighet når vi beveger oss
		$AnimationPlayer.speed_scale = 4
	else:
		$AnimationPlayer.speed_scale = 1
	
	# fart på bakken, basert på retning og fart deklarert i toppen
	target_velocity.x = direction.x * speed
	target_velocity.z = direction.z * speed
	
	#hopping
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		target_velocity.y = jump_impulse
	# hopperotasjon
	$Pivot.rotation.x = PI / 6 * velocity.y / jump_impulse
	
	# dettefart. Litt usikker hva i delta som blir lest, når det bare er forskjeller?
	if not is_on_floor(): # artig at det er egen deteksjon for
		target_velocity.y = target_velocity.y - (fall_acceleration * delta)
	
	#Skjekker om vi kontakter med fiender
	for index in range(get_slide_collision_count()):
		#hent det vi kræsjer med til variabel
		var collision = get_slide_collision(index)
		
		#om mob blir squashed så sletter den og vi får error.
		#hvis det skjer er det lurt med continue
		if collision.get_collider() == null:
			# så går vi videre til neste index
			continue
		
		#om det er mob
		if collision.get_collider().is_in_group("mob"):
			#lage mobvariabel
			var mob = collision.get_collider()
			#sjekk vinkel. Normalen er 3D-vektoren hvor kollisjonen hendte
			#om den er mer en 0.1 over 0 opp vil den trigge
			#trigger uansett med disse verdiene med mindre mer blir lagt til for å drepe player
			if Vector3.UP.dot(collision.get_normal()) > 0.1:
				mob.squash()
				target_velocity.y = bounce_impulse
				#sjekker bare en og hopper ut
				break
	
	# velocity er innebygget og vanskelig å bølle med, så vi setter den til t_v
	velocity = target_velocity
	# funksjon for å få alt til å røre seg
	move_and_slide()

func die() -> void:
	hit.emit()
	queue_free()

func _on_mob_detector_body_entered(_body: Node3D) -> void:
	die()
