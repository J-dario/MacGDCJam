extends Node3D

@onready var mesh_instance_3d: MeshInstance3D = $MeshInstance3D
@onready var omni_light_3d: OmniLight3D = $OmniLight3D

var targetScale = Vector3.ONE
var targetEnergy := 4.0

func _process(delta: float) -> void:
	if randf() < 0.2:
		targetScale = Vector3(randf_range(0.4, 0.6), randf_range(0.4, 0.6), randf_range(0.4, 0.6))
		targetEnergy = randf_range(3.0, 5.0)

	mesh_instance_3d.scale = mesh_instance_3d.scale.lerp(targetScale, delta * 8)
	omni_light_3d.light_energy = lerp(omni_light_3d.light_energy, targetEnergy, delta * 8)
