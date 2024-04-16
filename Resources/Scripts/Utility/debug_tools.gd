class_name DebugTool extends Node


#A rajzoló függvényekhez az alapot erről a GitHub Projectről mintáztam viszont át lettek írva. https://github.com/Ryan-Mirch/Line-and-Sphere-Drawing
#Funkcionalitásban Unitynek a Gizmoihoz lehet hasonlítani de Godotban csak 2Dhez van alapból ilyen függvény
func draw_line(start: Vector3, end: Vector3) -> void:
	var mesh_instance := MeshInstance3D.new()
	var immediate_mesh := ImmediateMesh.new()
	var material := StandardMaterial3D.new()

	mesh_instance.mesh = immediate_mesh
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF

	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
	immediate_mesh.surface_add_vertex(start)
	immediate_mesh.surface_add_vertex(end)
	immediate_mesh.surface_end()

	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = Color.YELLOW

	destroy_timer(mesh_instance, 1)


func draw_line_color(start: Vector3, end: Vector3, color: Color) -> void:
	var mesh_instance := MeshInstance3D.new()
	var immediate_mesh := ImmediateMesh.new()
	var material := StandardMaterial3D.new()

	mesh_instance.mesh = immediate_mesh
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF

	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
	immediate_mesh.surface_add_vertex(start)
	immediate_mesh.surface_add_vertex(end)
	immediate_mesh.surface_end()
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = color

	destroy_timer(mesh_instance, 1)


func draw_sphere(
	pos: Vector3, radius := 0.05, color := Color.WHITE_SMOKE, lifetime: float = 1
) -> void:
	var mesh_instance := MeshInstance3D.new()
	var sphere_mesh := SphereMesh.new()
	var material := StandardMaterial3D.new()

	mesh_instance.mesh = sphere_mesh
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	mesh_instance.position = pos

	sphere_mesh.radius = radius
	sphere_mesh.height = radius * 2
	sphere_mesh.material = material

	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = color

	destroy_timer(mesh_instance, lifetime)


func destroy_timer(node: Node, time: float) -> void:
	get_tree().get_root().add_child(node)
	await get_tree().create_timer(time).timeout
	node.queue_free()
