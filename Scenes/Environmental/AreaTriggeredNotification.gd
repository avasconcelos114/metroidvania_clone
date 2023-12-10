extends Area2D
class_name NotificationTrigger

@export var notification: ScreenNotification
@export var message := ''
@export var duration := 3

func _ready():
	body_entered.connect(send_notification)

func send_notification(body):
	if body is Player:
		notification.emit_signal("ShowTextSignal", message, duration)
		queue_free()
