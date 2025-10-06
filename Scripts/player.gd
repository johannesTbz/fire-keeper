extends CharacterBody2D

var enemy_inAttackRange = false
var enemy_AttackCooldown = true
var health = 100
var playerAlive = true

var attack_inpr = false

const speed = 100
var current_dir = "none"

@export var inv: Inv

func _ready():
	$AnimatedSprite2D.play("Idle front")
	
func _physics_process(delta):
	player_movement(delta)
	enemyAttack()
	attack()
	
	if health <= 0:
		playerAlive = false #death/respawn screen here
		health = 0
		print ("Du dog!")
		self.queue_free()

func player_movement(delta):
	
	if Input.is_action_pressed("ui_right"):
		current_dir = "right"
		play_anim(1)
		velocity.x = speed
		velocity.y = 0
		
	elif Input.is_action_pressed("ui_left"):
		play_anim(1)
		current_dir = "left"
		velocity.x = -speed
		velocity.y = 0
		
	elif Input.is_action_pressed("ui_down"):
		play_anim(1)
		current_dir = "down"
		velocity.y = speed
		velocity.x = 0
		
	elif Input.is_action_pressed("ui_up"):
		play_anim(1)
		current_dir = "up"
		velocity.y = -speed
		velocity.x = 0
		
	else:
		play_anim(0)
		velocity.x = 0
		velocity.y = 0
		
	move_and_slide()

func play_anim(movement):
	var dir = current_dir
	var anim = $AnimatedSprite2D
	
	if dir == "right":
		anim.flip_h = false
		if movement == 1:
			anim.play("Walk side")
		elif movement == 0:
			if attack_inpr == false:
				anim.play("Idle side")
	
	if dir == "left":
		anim.flip_h = true
		if movement == 1:
			anim.play("Walk side")
		elif movement == 0:
			if attack_inpr == false:
				anim.play("Idle side")
	
	if dir == "down":
		anim.flip_h = false
		if movement == 1:
			anim.play("Walk front")
		elif movement == 0:
			if attack_inpr == false:
				anim.play("Idle front")
	
	if dir == "up":
		anim.flip_h = false
		if movement == 1:
			anim.play("Walk back")
		elif movement == 0:
			if attack_inpr == false:
				anim.play("Idle back")
			
func player():
	pass
		
func _on_player_hitbox_body_entered(body: Node2D) -> void:
	if body.has_method("tree"):
		enemy_inAttackRange = true


func _on_player_hitbox_body_exited(body: Node2D) -> void:
	if body.has_method("tree"):
		enemy_inAttackRange = false
		
func enemyAttack():
	if enemy_inAttackRange and enemy_AttackCooldown == true:
		health = health - 10
		enemy_AttackCooldown = false
		$attack_cooldown.start()
		print(health)

func _on_attack_cooldown_timeout() -> void:
	enemy_AttackCooldown = true
	
func attack():
	var dir = current_dir
	
	if Input.is_action_just_pressed("attack"):
		Global.player_currently_attacking = true
		attack_inpr = true
		if dir == "right":
			$AnimatedSprite2D.flip_h = false
			$AnimatedSprite2D.play("Attack side")
			$deal_attack_timer.start()
		if dir == "left":
			$AnimatedSprite2D.flip_h = true
			$AnimatedSprite2D.play("Attack side")
			$deal_attack_timer.start()
		if dir == "down":
			$AnimatedSprite2D.play("Attack front")
			$deal_attack_timer.start()
		if dir == "up":
			$AnimatedSprite2D.play("Attack back")
			$deal_attack_timer.start()


func _on_deal_attack_timer_timeout() -> void:
	$deal_attack_timer.stop()
	Global.player_currently_attacking = false
	attack_inpr = false
