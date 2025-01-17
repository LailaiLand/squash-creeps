extends CharacterBody3D

# @export eksponerer variablene så de kan brukes av andre noder
# hastighet er gitt i m/s
@export var speed = 14
@export var fall_acceleration = 75
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
	
	# fart på bakken, basert på retning og fart deklarert i toppen
	target_velocity.x = direction.x * speed
	target_velocity.z = direction.z * speed
	
	# dettefart. Litt usikker hva i delta som blir lest, når det bare er forskjeller?
	if not is_on_floor(): # artig at det er egen deteksjon for
		target_velocity.y = target_velocity.y - (fall_acceleration * delta)
	
	# velocity er innebygget og vanskelig å bølle med, så vi setter den til t_v
	velocity = target_velocity
	# funksjon for å få alt til å røre seg
	move_and_slide()
