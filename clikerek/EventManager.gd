extends Node

signal trigger_event(event_name: String)

var event_timer: Timer

func _ready() -> void:
	event_timer = Timer.new()
	event_timer.wait_time = 15.0
	event_timer.autostart = true
	event_timer.timeout.connect(_on_event_timeout)
	add_child(event_timer)

func _on_event_timeout() -> void:
	var events = ["jumpscare", "theft", "bonus"]
	var chosen = events[randi() % events.size()]
	trigger_event.emit(chosen)
