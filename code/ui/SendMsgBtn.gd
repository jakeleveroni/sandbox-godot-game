extends Button

signal send_websocket_message(message: String)

func _pressed() -> void:
	print("Clicked Send Message Button");
	send_websocket_message.emit("TODO grab message as json here")

func _ready() -> void:
	print("Inside Ready")
