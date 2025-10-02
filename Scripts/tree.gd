extends StaticBody2D

var health = 100
var player_InAttack_Zone = false
var can_take_damage = true
var is_falling: bool = false

@onready var anim: AnimationPlayer = $AnimationPlayer

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	deal_with_damage()

func _on_hurtbox_tree_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		player_InAttack_Zone = true

func _on_hurtbox_tree_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		player_InAttack_Zone = false

func deal_with_damage():
	if player_InAttack_Zone and Global.player_currently_attacking == true:
		if can_take_damage == true:
			health = health - 20
			$Take_damage_cooldown.start()
			can_take_damage = false
			print("tree health = ", health)
			if health <= 0:
				start_fall()
				
func start_fall():
	is_falling = true
	anim.play("Fall")
	$HurtboxTree.monitoring = false
	$CollisionShape2D.disabled = true
	
func _on_take_damage_cooldown_timeout() -> void:
	can_take_damage = true	

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Fall":
		queue_free()
