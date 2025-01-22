extends Node

@export var mob_scene: PackedScene

# Ready kjører på starten for å gjøre klar til resten
# jeg tror ikke den må være på starten, men siden den går først så ser det bedre ut
func _ready() -> void:
	$UserInterface/Retry.hide()

func _on_timer_timeout() -> void:
	#den ble lagt til via editor etter export
	var mob = mob_scene.instantiate()
	
	var mob_spawn_location = get_node("SpawnPath/SpawnLocation")
	#prog_rat var ikke i autofyll? Men det er i documentation
	mob_spawn_location.progress_ratio = randf()
	
	var player_position = $Player.position
	#sender location til koden i Mob som regner ut rotasjon med lookat
	mob.initialize(mob_spawn_location.position, player_position)
	
	#så når den er instansert og rotert og har fått riktig fart så kan den legges til
	add_child(mob)
	
	#siden mob ikke er i main scene, kan den ikke connecte med editor
	#heldigvis kan vi gjøre det med kode
	mob.squashed.connect($UserInterface/ScoreLabel._on_mob_squashed.bind())


func _on_player_hit() -> void:
	$Timer.stop()
	$UserInterface/Retry.show()

# Tror denne skjekker når du trykker noe hele tiden uansett
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept") and $UserInterface/Retry.visible:
		# Restarter når retry-skjermen er åpen
		get_tree().reload_current_scene()
