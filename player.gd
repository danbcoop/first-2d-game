extends Area2D
signal hit

@export var speed = 400
var screen_size

var config = ConfigFile.new()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size
	hide()
	
	# Parse cfg-file into native dialoge object
	var err = config.load("res://dialogs/_template.cfg")
	var dia_obj = {}
	if err == OK:
		for section in config.get_sections():
			dia_obj[section] = {}
			dia_obj[section]["id"] = section
			for key in config.get_section_keys(section):
				dia_obj[section][key] = config.get_value(section, key)
				
	# var choice_count = -1
	# for choice in dia_obj["section_id"]["choices"]:
	# 	choice_count += 1
	# 	print(choice_count, choice["next"])
	# 	for nxt in choice["next"]:
	# 		if nxt == "section_id":
	# 			pass
	# dia_obj["section_id"]["choices"][choice_count]["next"] = [ "section_id" ]
	print(dia_obj)
	# config.set_value("section_id", "choices", dia_obj["section_id"]["choices"])
	# config.save("res://dialogs/_template.cfg")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var velocity = Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
	
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "up"
	
	# $AnimatedSprite2D.flip_v = position.y > screen_size.y/2

	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	
	
func start(pos: Vector2) -> void:
	position = pos
	show()
	$CollisionShape2D.disabled = false


func _on_body_entered(_body: Node2D) -> void:
	hide()
	hit.emit()
	$CollisionShape2D.set_deferred("disabled", true)
