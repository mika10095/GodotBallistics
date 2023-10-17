extends Node

@export var Diameter : float 
@export var Length : float
@export var Velocity : float 
@export var Mass : float 
@export var Twist : float 
@export var fp : Node
@export var env : Node
var semiauto = true;

# Called when the node enters the scene tree for the first time.
func _ready():
	fp = get_node("../Barrel/FirePoint")
	env = EnviromentSetup
func _spawm_bullet():
	var bullet = load("res://bullet.tscn")
	var projectile = bullet.instantiate()
	projectile.global_transform = fp.global_transform
	projectile.Setup(Velocity)
	get_tree().root.add_child(projectile)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(!Input.is_physical_key_pressed(KEY_ENTER)):
		semiauto = true
	if(Input.is_physical_key_pressed(KEY_ENTER) && semiauto):
		_spawm_bullet()
		semiauto = false
