extends Resource
class_name AerodynamicData
@export var altitude:float = 0
@export var atmospheric_pressure:float = 101325
@export var atmospheric_density:float = 1.225

func _init(altitude_new:float,atmospheric_pressure_new:float,atmospheric_density_new:float):
	altitude = altitude_new
	atmospheric_pressure = atmospheric_pressure_new
	atmospheric_density = atmospheric_density_new
