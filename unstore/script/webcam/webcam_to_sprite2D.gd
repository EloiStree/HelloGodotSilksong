extends Node2D

@export var base_material: CanvasItemMaterial  # For 2D materials
@export var cam_texture: CameraTexture  # To be assigned or created at runtime

func _ready():
	if cam_texture == null:
		# Try to generate a CameraTexture at runtime if not assigned
		if CameraServer.get_feed_count() > 0:
			var feed = CameraServer.get_feed(0)
			if feed.is_active() == false:
				feed.set_active(true)  # Ensure the feed is active

			cam_texture = CameraTexture.new()
			cam_texture.camera_feed_id = feed.get_id()
			print("Camera feed ID: ", feed.get_id())  # Debugging feed ID
		else:
			print("No camera feed detected")
			return  # Exit early if no texture is available

	# Ensure base_material is valid
	var material_to_use: CanvasItemMaterial
	if base_material != null:
		material_to_use = base_material.duplicate()
	else:
		print("No base_material assigned. Using default material.")
		material_to_use = CanvasItemMaterial.new()  # Default material for 2D

	# Create a Sprite2D node
	var sprite = Sprite2D.new()

	# Apply the camera texture to the sprite
	sprite.texture = cam_texture

	# Set up the material for the sprite (if available)
	sprite.material = material_to_use

	# Add the sprite as a child node
	add_child(sprite)

	# Debugging: Check material and texture assignment
	print("Assigned texture to sprite: ", sprite.texture)
