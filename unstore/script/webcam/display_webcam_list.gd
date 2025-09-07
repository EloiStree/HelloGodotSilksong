extends Node

func _ready():
	var count = CameraServer.get_feed_count()
	if count == 0:
		print("No webcams detected")
		return
	
	print("Available webcams:")
	for i in count:
		var feed = CameraServer.get_feed(i)
		print(str(i) + ": " + feed.get_name())
