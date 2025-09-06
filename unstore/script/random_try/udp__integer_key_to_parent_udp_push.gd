extends Button

# Designer can assign a starting parent node in the editor (optional)
@export var parent_node_path: NodePath

# Integer to send when the button is pressed
@export var press_integer: int = 1300

# Integer to send when the button is released
@export var release_integer: int = 2300

# Store reference to the parent UDP sender with the required method
var parent_udp_sender: Node = null

func _ready() -> void:	
	
	self.button_down.connect(_on_button_pressed)
	self.button_up.connect(_on_button_released)

	# If a specific parent node path is assigned, start checking from there
	if parent_node_path:
		var start_node = get_node_or_null(parent_node_path)
		if start_node:
			parent_udp_sender = find_parent_with_method(start_node)
	else:
		# Otherwise, start checking from the immediate parent
		parent_udp_sender = find_parent_with_method(get_parent())
	
	# Validate that a parent with the required function was found
	if parent_udp_sender == null:
		push_error("No parent found with 'send_integer_le(value: int)' function!")

# Recursively search for a parent node with the send_integer_le method
func find_parent_with_method(node: Node) -> Node:
	if node == null:
		return null
	
	if node.has_method("send_integer_le"):
		return node
	
	return find_parent_with_method(node.get_parent())

# Call this function to send integer through parent UDP sender
func push_integer(value: int) -> void:
	if parent_udp_sender:
		parent_udp_sender.send_integer_le(value)
	else:
		push_error("Cannot send integer: Parent UDP sender not set or invalid.")

# Handle button press event
func _on_button_pressed() -> void:
	
	print( "Send press int:"+str(press_integer))
	push_integer(press_integer)

# Handle button release event
func _on_button_released() -> void:
	print( "Send release int:"+str(release_integer))
	push_integer(release_integer)
