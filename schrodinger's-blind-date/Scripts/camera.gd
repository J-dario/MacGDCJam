extends Camera3D

var swayTime: float = 0.0

@export var SWAY_SPEED := 0.4
@export var SWAY_AMOUNT := 0.004
@export var BOB_AMOUNT := 0.0800

var basePosition: Vector3
var baseRotation: Vector3

func _ready() -> void:
	basePosition = position
	baseRotation = rotation

func _process(delta: float) -> void:
	swayTime += delta

	rotation.z = baseRotation.z + sin(swayTime * SWAY_SPEED) * SWAY_AMOUNT
	position.y = basePosition.y + sin(swayTime * SWAY_SPEED * 1.3) * BOB_AMOUNT
	position.x = basePosition.x + sin(swayTime * SWAY_SPEED * 0.7) * BOB_AMOUNT * 0.5
