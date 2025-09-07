extends Node3D
var cam_texture: CameraTexture
func _ready():
	if CameraServer.get_feed_count() > 0:
		var feed = CameraServer.get_feed(0) 
		feed.set_active(true) 

		cam_texture = CameraTexture.new()
		cam_texture.camera_feed_id = feed.get_id()

		var cube = MeshInstance3D.new()
		cube.mesh = BoxMesh.new()

		var mat = StandardMaterial3D.new()
		mat.albedo_texture = cam_texture
		cube.set_surface_override_material(0, mat)

		add_child(cube)
	else:
		print("No camera feed detected")
