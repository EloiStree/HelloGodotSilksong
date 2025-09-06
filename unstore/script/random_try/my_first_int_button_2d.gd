extends Button

# Sever APINT default IP 193.150.14.47
# Editable variables in Inspector
@export var _target_ip : String = "127.0.0.1"  # broadcast address
@export var _target_port : int = 3615
@export var _press_value : int = 1034           # your integer

# Networking
var udp := PacketPeerUDP.new()

func _ready():
	# Enable UDP broadcast
	udp.set_broadcast_enabled(true)
	print("UDP broadcast ready. Sending to %s:%d" % [_target_ip, _target_port])
	
	# Connect button signals
	self.button_down.connect(_on_Button_pressed)
	self.button_up.connect(_on_Button_released)

# Called when the button is pressed
func _on_Button_pressed():
	send_value(_press_value)

# Called when the button is released
func _on_Button_released():
	send_value(_press_value + 1000)

# Helper function to send an integer as a packet
func send_value(value: int):
	var data = str(value).to_utf8_buffer()
	udp.connect_to_host(_target_ip, _target_port)
	udp.put_packet(data)
	print("Sent:", value)
