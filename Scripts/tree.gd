extends Node2D

var health = 100
var player_InAttack_Zone = false
var can_take_damage = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	deal_with_damage()

func tree():
	pass


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
				self.queue_free()
	
func _on_take_damage_cooldown_timeout() -> void:
	can_take_damage = true
