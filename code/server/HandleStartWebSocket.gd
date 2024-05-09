extends Button

signal toggle_websocket_server

func _pressed() -> void:
	print("Clicked Start Web Socket Button");
	var prev = get_text()
	var next = "Stop Websocket Server"
	
	if prev.contains("Stop"):
		next = "Start Websocket Server"
		toggle_websocket_server.emit("1")
	else:
		toggle_websocket_server.emit("0")

	set_text(next)

func _ready() -> void:
	print("Inside Ready")
	print("Is Pressed: ", is_pressed())
	print("Is Disabled: ", is_disabled())
