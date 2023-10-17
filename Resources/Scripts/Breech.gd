extends Node

@export var Diameter : float 
@export var Velocity : float 
@export var Mass : float 
@export var Twist : float 

# Called when the node enters the scene tree for the first time.
func _ready():
	var fp = get_node("../Barrel/FirePoint")
	var env = EnviromentSetup
func _spawm_bullet():
	var bullet = load("res://bullet.tscn")
	var projectile = bullet.instantiate()
	projectile.Setup(Diameter)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(Input.is_physical_key_pressed(KEY_ENTER)):
		_spawm_bullet()
		
