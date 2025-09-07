extends Node3D

@export var base_material: StandardMaterial3D
@export var cam_texture: CameraTexture

func _ready():
	if cam_texture == null:
		# Try to generate a CameraTexture at runtime if not assigned
		if CameraServer.get_feed_count() > 0:
			var feed = CameraServer.get_feed(0)
			if feed.is_active() == false:
				feed.set_active(true)  # Make sure the feed is active

			cam_texture = CameraTexture.new()
			cam_texture.camera_feed_id = feed.get_id()
			print("Camera feed ID: ", feed.get_id())  # Debugging feed ID
		else:
			print("No camera feed detected")
			return  # Exit early if no texture is available

	# Ensure base_material is valid
	var material_to_use: StandardMaterial3D
	if base_material != null:
		material_to_use = base_material.duplicate()
	else:
		print("No base_material assigned. Using default material.")
		material_to_use = StandardMaterial3D.new()

	# Apply the camera texture
	material_to_use.albedo_texture = cam_texture

	# Set up cube with material
	var cube = MeshInstance3D.new()
	cube.mesh = BoxMesh.new()
	cube.set_surface_override_material(0, material_to_use)
	add_child(cube)

	# Debugging: Ensure the material is using the right texture
	print("Assigned texture to material: ", material_to_use.albedo_texture)
