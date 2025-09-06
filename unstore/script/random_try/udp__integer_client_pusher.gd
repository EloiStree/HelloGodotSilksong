extends Node

# Designer-exposed variables
# Sever APINT default IP 193.150.14.47
@export var target_ip: String = "127.0.0.1"  # Default broadcast
@export var target_port: int = 3615


# Networking
var udp := PacketPeerUDP.new()

func _ready():
	# Enable UDP broadcast
	udp.set_broadcast_enabled(true)
	print("UDP broadcast ready. Sending to %s:%d" % [target_ip, target_port])

func send_integer_le(value: int) -> void:
	var data = PackedByteArray()
	# Convert integer to 4 bytes little-endian
	data.append(value & 0xFF)
	data.append((value >> 8) & 0xFF)
	data.append((value >> 16) & 0xFF)
	data.append((value >> 24) & 0xFF)

	udp.connect_to_host(target_ip, target_port)
	udp.put_packet(data)
	print("Sent:", value, "as little-endian bytes:", data)



func _setup_udp() -> void:
	udp.close()
	udp = PacketPeerUDP.new()
	udp.set_broadcast_enabled(true)




func set_target(ip: String, port: int) -> void:
	target_ip = ip
	target_port = port
	_setup_udp()
	print("UDP target updated to %s:%d" % [target_ip, target_port])
